---
title: "Designing Backends for AI Agents First Humans Second - The Architecture Nobody Taught You"
description: "Most backend APIs were designed for developers — humans who read docs, ask questions, and adapt when something breaks. AI agents can't do any of that. This post walks through the real gaps: undocumented side effects that fool agents into firing live emails in test runs, request-count rate limiting that looks like a DDoS to a bursty agent workflow, and the surprising difference a capability registry makes when an agent needs to plan before it acts. Includes practical patterns like x-side-effects OpenAPI extensions, consumption-based metering, and the A2A protocol — and how Stripe, Twilio, and Google are already building with them."
date: 2026-05-21T00:14:36Z
lastmod: 2026-05-21T00:14:36Z
keywords:
  [
    "AI",
    "ai-development",
    "AgenticAI",
    "Agents",
    "model-context-protocol",
    "MCP Servers",
    "Claude",
    "ai-tools",
    "agent-first",
    "a2a-protocol",
  ]
tags:
  [
    "AI",
    "ai-development",
    "Agent.ai",
    "AgenticAI",
    "Agents",
    "MCP Servers",
    "ai-tools",
  ]
categories: ["AI", "Development", "AgenticAI", "Agents"]
layout: post
type: "post"
---

I had a bad dream... a disturbing one...

I plugged an AI agent into a production internal API. The API had been running in production for many years. Solid REST design, reasonable error handling, decent OpenAPI coverage. By every measure we used when we built it, it was a good API.

**The agent broke it in about four minutes.**

<!--more-->

![header image](/img/hero_designing-backends-for-ai-agents.jpg)
_[The AI agent that broke the API]_

Not catastrophically: no data corruption, no cascading failures. But the agent got stuck in a retry loop on a vague `400 Bad Request` that gave it no signal about what was actually wrong. It hit the same endpoint nine times in sixty seconds. It called a `POST /transfer` endpoint twice because the first call timed out and it had no way of knowing whether the operation had actually gone through. It hallucinated a query parameter that appeared in some of our other endpoints but not this one, and when it got back a `404`, it concluded the entire resource didn't exist rather than that it had called the endpoint wrong.

None of these things would have happened with a human developer at the keyboard. A human reads the error message and looks up the docs. A human waits before retrying when they're not sure if a write went through. A human notices the pattern and adapts. The agent just executed, and in doing so, it exposed every assumption we'd quietly baked into the API over the years, assumptions that only worked because a human was on the other end.

I woke up, rattled. Not because it was a bad dream, but because **I realized that the problem was real**.

Every piece of API design education most of us received (REST conventions, OpenAPI specs, HTTP status semantics) was written for a world where the consumer was a developer with a browser tab, a Slack channel, and the ability to ask questions. AI agents don't have any of that. Building backends they can actually use requires rethinking some things we thought were settled.

## The Side Effect Problem Nobody Put in the Spec

Here's the principle that changed how I think about this: describe the side effect, not just the shape.

OpenAPI is excellent at describing what goes in and what comes out. Parameters, request bodies, response schemas: all documented. What it doesn't capture is what happens in between. Does this POST write to a database? Does it trigger an async job that you'll need to poll separately? Does it deduct from a quota? Does it send an email? Is it idempotent?

Human developers learn this from README files, Stack Overflow threads, internal wikis, and the painful experience of discovering a `POST /send-invoice` endpoint fires an actual email to an actual customer when you test it in staging. They build up a mental model of the side effect topology over time. It's implicit knowledge, shared verbally, never formally captured.

Agents don't accumulate implicit knowledge. They work from what you give them. If your OpenAPI spec says a `POST /orders` endpoint takes a `product_id` and returns an `order_id`, that's what the agent knows. It doesn't know the request also sends a confirmation email, reserves inventory, and triggers a fulfillment workflow. So it'll call that endpoint in a test context and wonder why a customer just got an order confirmation for a QA transaction.

The fix isn't complicated, but it requires a mindset shift: treat side-effect documentation as a first-class element of your API contract, not a nice-to-have in the README. In practice this looks like adding an `x-side-effects` extension to your OpenAPI spec:

```yaml
paths:
  /orders:
    post:
      summary: Create a new order
      x-side-effects:
        - type: email
          description: Sends order confirmation to customer email on file
        - type: inventory
          description: Reserves inventory for all line items; non-reversible without explicit cancel
        - type: async
          description: Triggers fulfillment workflow; poll /orders/{id}/status for completion
      x-idempotent: false
      x-idempotency-key-required: true
```

> Note: The `x-side-effects` is an unofficial, vendor-specific OpenAPI extension commonly used in agentic and programmatic API frameworks such as [AgenticAPI](https://agenticapi.com/docs/openapi-extensions/) to annotate endpoints with out-of-band impacts (e.g., database changes, sent emails, or payment charges)

This is not in the OpenAPI 3.x standard. It's a convention you establish. But when you pass this spec to an agent via Anthropic's MCP or Google's Agent Development Kit (ADK), the agent now knows to require an idempotency key before calling this endpoint, to not call it in read-only planning passes, and to check fulfillment status asynchronously rather than expecting a synchronous result. That's a completely different quality of agent behavior, and it costs you a few extra lines in the spec.

## Token-Based Rate Limiting Is a Different Problem Than You Think

Most of us grew up rate-limiting by request count. Stripe allows N API calls per second. Twilio allows N messages per minute. This made sense when every API call was one human decision: one button click, one form submit, one developer trigger.

AI agents don't work like that. An agent planning a multi-step workflow will fan out to your API in ways that look nothing like human usage patterns. I've watched agents fire forty tool calls inside a single reasoning step because the task required checking forty things to make a decision. Forty calls in under a second, all legitimate, all from a single authorized session. Under request-count rate limiting, this looks like a DDoS. The agent hits your limit, gets back a `429`, has no idea whether it should slow down or retry immediately, and either grinds to a halt or hammers you in a backoff loop.

The emerging solution is rate limiting by resource consumption rather than request count. What did this session actually cost? How many tokens got processed? How much compute time was consumed? This is how Stripe is thinking about metering in their agentic infrastructure work, and it maps much more naturally to the bursty, high-volume patterns agents generate.

For most teams this requires new backend instrumentation. You need to emit consumption metrics per session, not just per request. You need to expose those metrics back to the agent in a form it can reason about: a `Retry-After` header is not enough; an agent that knows it has consumed 80% of its compute budget in this session can plan differently, batching remaining calls or deferring non-critical ones. That's behavioral information, not just a throttle.

If you're building this today, look at how Twilio is approaching agentic billing in their SIGNAL 2026 releases. Their `Agent Connect` GA release exposes quota state as a structured API response, not just a rate limit error. The agent gets context, not just a stop sign.

## Self-Describing Backends: What Actually Helps Agents Plan

One of the more revealing things I've seen in practice is what happens when you give an agent two different API surfaces for the same underlying platform.

In one case: a standard OpenAPI spec with path descriptions, parameter types, and response schemas. The agent calls endpoints, gets results, makes wrong assumptions, calls the wrong endpoint for a use case, tries to chain two endpoints that weren't designed to chain. It works eventually, but it's noisy.

In the other case: the same platform with a `/capabilities` endpoint that returns a structured manifest: every action the API can perform, grouped by intent, with side effects documented, with cost and latency characteristics, with explicit pointers to related actions. The agent calls this first, builds a plan, then executes. Tool-call failures drop sharply. The reasoning is cleaner. The whole thing takes fewer steps.

This pattern is called a **capability registry**. Stripe built one into [Stripe Projects](https://docs.stripe.com/projects), announced at [Sessions 2026](https://stripe.com/newsroom/news/sessions-2026), and it's what lets an AI coding agent run `stripe projects provision` or `stripe projects catalog` against a catalog of 32 infrastructure partners (Render, Sentry, Twilio, Vercel, and others) using a single standardized interface. The agent doesn't need to know any partner's individual API surface. It just knows what the Stripe Projects catalog can do, and it asks for what it needs.

Google's [A2A (Agent-to-Agent) protocol](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/), [donated to the Linux Foundation in June 2025](https://developers.googleblog.com/en/google-cloud-donates-a2a-to-linux-foundation/) and now backed by [150+ organizations](https://www.linuxfoundation.org/press/a2a-protocol-surpasses-150-organizations-lands-in-major-cloud-platforms-and-sees-enterprise-production-use-in-first-year) across supply chain, financial services, and IT ops, formalizes this idea at the inter-agent level. An agent publishes an Agent Card at `/.well-known/agent-card.json`: a machine-readable description of its capabilities, endpoints, authentication requirements, and declared skills. Other agents discover it, evaluate whether it can satisfy a sub-task, and delegate to it. It's the same capability-registry concept applied to agents calling agents rather than clients calling backends.

For your own platform, you don't need to implement full A2A to get value from this. Start simpler: a single `GET /agent/capabilities` endpoint that returns structured JSON describing what your API can do, grouped by the intent categories your users actually care about. If you're building a logistics platform, that's probably `shipment-management`, `carrier-selection`, `tracking`, and `billing`. Let the agent orient first, then act.

The [Arazzo specification](https://www.openapis.org/arazzo-specification) (v1.0.1, stable since January 2025) is worth looking at here too: it's an OpenAPI Initiative project under Linux Foundation governance that formalizes multi-step API workflows as machine-readable contracts with step ordering, success criteria, and conditional branching. Unlike `llms.txt`, which is a community convention with no major AI provider committed to reading it in production, Arazzo is a ratified specification with a Technical Steering Committee behind it. It lets you formally declare that "to create a shipment, call `/carrier-quote` first, pass the `quote_id` to `/shipment/create`, then call `/shipment/{id}/label`" — not as a prose tutorial, but as a contract an agent can execute deterministically.

## Key Takeaways

- Side effects belong in the spec, not the README. Use `x-side-effects`, `x-idempotent`, and `x-idempotency-key-required` extensions to make your OpenAPI contract honest about what an endpoint actually does. Agents work from what you give them — implicit knowledge doesn't transfer.

- Request-count rate limiting breaks under agent traffic. Agents fan out — forty legitimate calls in a second is normal agent behavior, not an attack. Move toward consumption-based quotas and expose quota state as structured data in your responses, not just `429` headers.

- Build a capability registry before you build agent integrations. A `GET /agent/capabilities` endpoint that groups your API by intent lets agents plan before they act. Stripe Projects does this at the platform level across 32 infrastructure partners; A2A Agent Cards do it at the inter-agent level. The pattern scales.

- A2A (backed by 150+ organizations under Linux Foundation governance) and Arazzo (v1.0.1, ratified by the OpenAPI Initiative) are production-ready specs. Build on them. `llms.txt` has no major AI provider committed to reading it in production — don't treat it as equivalent.

- Semantic richness helps human developers too. Side-effect annotations, structured capability registries, and Arazzo workflow contracts make the implicit knowledge in your system explicit. Teams that have done this report faster onboarding for human integrators as a side effect.

- Don't retrofit AI onto a human-centric API. Adding an AI shim on top of an API that wasn't designed for agent consumption doesn't fix the underlying problems — it buries them. Idempotency, side-effect transparency, and capability description need to be designed in, not bolted on.

## Where Do You Start?

The gap between "API that works fine when a human is calling it" and "API that an agent can use reliably" is real, but it's not mysterious. The patterns exist. Idempotency keys, side-effect annotations, capability registries, consumption-based rate limiting: these are all implementable today, with specifications and production examples to reference.

The hard part isn't the technology. It's the mindset shift. We've spent a decade building APIs for developers, and good developer experience meant ergonomic REST conventions, clean error messages a human can read, and documentation a human will eventually find. Agent experience requires something more explicit, more formal, and more honest about what an endpoint actually does.

Stripe figured this out. Twilio is in the middle of figuring it out. The platforms that get there first become the default building blocks in agentic workflows, not because of marketing, but because agents can actually use them without constant human supervision.

## The Shift That's Already Happening

The dream at the start of this post wasn't really a nightmare — it was a diagnostic. A well-built API, years of production hardening, failing in four minutes because the consumer was an agent instead of a developer. The API didn't break. The assumptions broke.

That's the actual shift: not the technology, but the contract. We built APIs assuming a human was always in the loop — reading errors, adapting, asking questions. Agents remove that assumption entirely. The implicit knowledge that lived in README files, Slack threads, and developer intuition now has to live in the spec.

The good news is the work is defined. Idempotency keys, side-effect annotations, capability registries, consumption-based quotas — none of these require you to rebuild your backend. They require you to be more honest about what your backend already does. The platforms doing this now aren't just better for agents. They're better documented, easier to onboard onto, and more resilient to misuse in general.

Agent-first isn't a replacement for human-first. It's a higher bar that benefits everyone.

If you're building a platform today and you haven't thought through what it looks like from an agent's perspective, that's worth putting on your backlog now.

Drop me a message if you've run into specific integration pain points. I'd genuinely like to hear what's breaking in your stack and what you've tried. The more of us sharing real patterns (and real failures), the faster everyone figures this out.
