---
title: "Agent.ai MCP Server Integration with Claude Desktop: A Step-by-Step Tutorial"
description: "A step-by-step tutorial to set up an Agent.ai MCP Server in Claude Desktop and explore the various possibilities MCP integration offers."
date: 2025-03-14T14:04:50-04:00
lastmod: 2025-03-14T14:04:50-04:00
keywords : [ "AI", "ai-development", "Agent.ai", "AgenticAI", "Agents", "model-context-protocol", "MCP Servers", "Claude", "ai-tools" ]
tags : [ "AI", "ai-development", "Agent.ai", "AgenticAI", "Agents", "MCP Servers", "ai-tools" ]
categories : [ "AI", "Development", "AgenticAI", "Agents" ]
layout: post
type:  "post"
---

In this article, we will set up an Agent.ai MCP Server in Claude Desktop and explore the various possibilities MCP integration offers.

The Model Context Protocol (MCP) significantly advances how Large Language Models (LLMs) interact with external tools and services. At its core, MCP is a standardized communication protocol that enables AI models to seamlessly integrate with various tools, expanding their capabilities beyond basic text generation.

MCP works by establishing a structured framework for tools to register their capabilities with LLMs and for LLMs to understand and utilize these tools effectively. When an LLM like Claude encounters a query that could benefit from external tools, it can identify the appropriate MCP-compatible tool, request permission to use it, and incorporate the retrieved information into its response. This creates a more dynamic and capable AI system that can access real-time data, perform complex calculations, or interact with external services.
<!--more-->

![General Architecture for MCP](https://github.com/user-attachments/assets/bba894a9-0399-4db2-9e78-47a9053224d4)
*[General Architecture for MCP - Image Credit [modelcontextprotocol.io](http://modelcontextprotocol.iohttps://modelcontextprotocol.io/introduction)]*

In the context of Claude, MCP integration allows the AI to enhance its responses with current information and specialized capabilities. For example, when asked about company financials or market data, Claude can utilize MCP-enabled tools like Agent.ai to access and analyze the most recent information. This integration ensures that responses are not just based on training data but incorporate up-to-date, accurate information from reliable sources.

The protocol's design emphasizes security and user control, requiring explicit permission before accessing external tools. This ensures transparency and maintains user autonomy while allowing for powerful tool-augmented conversations. As more tools become MCP-compatible, the potential applications and capabilities of LLMs like Claude continue to expand, creating more versatile and practical AI assistants.

> Read all about [Model-Context-Protocol](https://modelcontextprotocol.io/introduction)

## Getting Started

- [Download](https://claude.ai/download) Claude Desktop
- Read the documentation for MCP Server provided by Agent.ai
    - Get an Agent.ai API key
    - Set up the MCP server with Claude Desktop

> If you are interested in using other MCP servers with Claude or any other MCP compatible LLM, see the [list here](https://github.com/modelcontextprotocol/servers).

### Getting an Agent.ai API Key

- To get an API token from Agent.ai follow the steps:
    - [Sign up](https://agent.ai/?referrer=rupakg) for an Agent.ai account (if you don’t have an account)
    - Login to your Agent.ai account
    - Click on the chevron next to your profile pic
    - Click on User Settings
    - Click on the Credit tab at the top
    - Scroll down to find your API Key

### Setting up the MCP Server with Claude Desktop

Follow the [instructions](https://docs.agent.ai/mcp-server) at Agent.ai to configure Claude Desktop. You will need your Agent.ai API key for this step. Here is the summary of the steps:

- Configure the server as instructed. Use either the NPX or the Docker config options
- This will open the `claude_desktop_config.json` for you to edit
- Paste your Agent.ai API key replacing `YOUR_API_TOKEN_HERE` in the config file
- Save the config file
- Restart Claude Desktop

You have two options to configure the Agent.ai MCP Server in Claude Desktop:

**NPX Config option**: (I used this option and it works great.)
```
{
  "mcpServers": {
    "agentai": {
      "command": "npx",
      "args": ["-y","@agentai/mcp-server"
      ],
      "env": {
        "API_TOKEN": "YOUR_API_TOKEN_HERE"
      }
    }
  }
}
```
**Docker Config option**:
```
{
  "mcpServers": {
    "agentai": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "API_TOKEN", "mcp/agentai"
      ],
      "env": {
        "API_TOKEN": "YOUR_API_TOKEN_HERE"
      }
    }
  }
}
```
> **Note**: You can read more about the Agent.ai MCP Server npm package at https://www.npmjs.com/package/@agentai/mcp-server


## Using MCP Tools with Claude Desktop

- Start a new chat in Claude
- Click the Tools icon in Claude

  ![MCP tools icon in Claude](https://github.com/user-attachments/assets/3c3fc73b-7e32-4439-ac24-093870be0675)

- Verify that you can see the Agent.ai MCP server listed.

  ![Installed MCP Servers on Claude](https://github.com/user-attachments/assets/afba9ae0-b011-44be-84ab-e8ebea291c89)

- And, clicking on the hammer icon you will see the available MCP Tools (not a full list in the screenshot)

  ![Available MCP Tools in Claude](https://github.com/user-attachments/assets/57ff9fd7-9232-47ee-9875-f098278edf27)

## Querying Claude Using Agent.ai Tools

To test out the fact that the MCP server config and Claude Desktop is setup correctly, try the following example:

💬 **Prompt**: Give me the latest company financial details about HubSpot

🗣️ **Claude Response**:

![Permissions to use tools in Claude](https://github.com/user-attachments/assets/70327e3a-b1a8-48b9-9a77-2699beeb4b63)

**Note**: Claude automatically identifies the MCP Server for Agent.ai that is configured, to be the best tool to use for this query. And, then asks permissions to use it. Note that you can give it permission to use for this chat or allow only once. 

I gave it permission to use the MCP tool for this chat.

### Issues

I kept getting an error from Claude saying that there was some network connection issues, and the Claude would kill the chat after trying for sometime.

![Errors in Claude](https://github.com/user-attachments/assets/e2c3ad90-9a79-497f-8a5b-cf54a52cf9cc)

### Enable Developer Mode

To enable Developer Mode and look at the logs, do the following:

- In Claude Desktop, go to Help → Enable Developer Mode
- Now, you will see a new menu item “Developer”
- You can also see the sub-menu item “Open MCP Log File”. This will be useful for troubleshooting issues

### Quota Capped by Claude

Looking at the logs, I figured that the above query was working correctly, as I could see the response from the Agent.ai MCP server as shown below:

```
{"company":"HUBS"}},"jsonrpc":"2.0","id":12}
2025-03-13T20:16:14.117Z [info] [agentai] Message from server: 
{"jsonrpc":"2.0","id":12,"result":{"content":
[{"type":"text","text":"{\n  \"response\": 
{\n    \"income_statement\": [\n      {\n        
\"acceptedDate\": \"2025-02-12 16:25:29\",\n        
\"calendarYear\": \"2024\",\n        
\"cik\": \"0001404655\",\n        
\"costAndExpenses\": 2695145000,\n 

...

\"fullTimeEmployees\": \"8246\",\n        
\"image\": \"https://images.financialmodelingprep.com/symbol/HUBS.png\",\n       
\"industry\": \"Software - Application\",\n        
\"ipoDate\": \"2014-10-09\",\n        
\"isActivelyTrading\": true,\n        \"isAdr\": false,\n        
\"isEtf\": false,\n        \"isFund\": false,\n        
\"isin\": \"US4435731009\",\n        \"lastDiv\": 0,\n        
\"mktCap\": 31204242792,\n        \"phone\": \"888 482 7768\",\n        
\"price\": 598.32,\n        \"range\": \"434.84-881.13\",\n        
\"sector\": \"Technology\",\n        \"state\": \"MA\",\n        
\"symbol\": \"HUBS\",\n        \"volAvg\": 527475,\n        
\"website\": \"https://www.hubspot.com\",\n        \"zip\": \"02141\"\n      
}\n    ]\n  },\n  \"status\": 200\n}"}],"isError":false}}
```

I am guessing since I have Claude’s Free Plan, the amount of data it can send back is limited, and I was being capped for content that was too large to be displayed.

To confirm my suspicion, I asked a very specific question about HubSpot that does not involve a lot of data.

💬 **Prompt**: Give the number of full-time employees in HubSpot

🗣️ **Claude Response**:

![Claude response](https://github.com/user-attachments/assets/e8922485-c6d9-413b-ae16-e7402097e202)

🫴🏼 **Takeaway**: And, I had the answer, but I guess the company info. API response was still pretty large as seen in the logs, and it exhausted the quota for output tokens in Claude. So, instead of using the more richer API from Agent.ai, Claude used a Google search to find the answer. Notice the key pair `"fullTimeEmployees\": \"8246\"` in the above JSON chunk that confirms the answer. 

It also shows how Claude can automatically switch between given tools to come up with an answer.

👉🏼 I was wondering that if the API call had a filter or allowed passing query params, for only specific items that I needed, the API response would have been smaller, and then Claude could return a response within the quota limits. That might be a significant design choice that API developers have to make when dealing with LLMs that call them via tools.

Let’s try another one.

💬 **Prompt**: Get domain info for chat.com

🗣️ **Claude Response**:

![Claude response](https://github.com/user-attachments/assets/59efc9fd-7fa3-4ad9-ac71-e9c2784d91d4)

🫴🏼 **Takeaway**: Claude inspected the tools available to it and correctly identified that it can call the `domain_info` tool from Agent.ai to get the results.

Here's the domain information for chat.com:

**Domain Details:**

- Domain name: chat.com
- Registration status: Active/Registered
- Creation date: September 20, 1996
- Expiration date: September 19, 2027
- Last updated: November 13, 2024

**Ownership Information:**

- Registrant organization: OpenAI
- Registrant location: California, United States

**Technical Details:**

- Name servers:
    - dahlia.ns.cloudflare.com
    - kip.ns.cloudflare.com
- Registrar: MarkMonitor, Inc. (IANA ID: 292)
- DNSSEC: signedDelegation

**Domain Status:**
The domain has multiple protection statuses applied (clientUpdateProhibited, clientTransferProhibited, clientDeleteProhibited, etc.) which indicates it's locked against unauthorized transfers or modifications.

The domain is currently owned by OpenAI and uses Cloudflare's nameservers for its DNS management.

🫴🏼 **Takeaway**: This time around the query worked and Claude returned the results as expected.

Let’s try another one.

💬 **Prompt**: Get 3 recent tweets from Sam Altman's Twitter account

🗣️ **Claude Response**:

![Claude response](https://github.com/user-attachments/assets/e497ce5e-1f7f-4b57-b5f0-0eb81eb08d2e)

I tried to retrieve Sam Altman's recent tweets, but it appears there was no data returned. This could be due to a few reasons:

1. There might be an issue with accessing Twitter data at the moment
2. The handle "sama" might not be returning results (though this is Sam Altman's known Twitter handle)
3. There might be API limitations

Let me try searching for his Twitter profile to confirm the handle:

![Claude response](https://github.com/user-attachments/assets/e24300b1-b430-4894-8dc6-58ab4250467e)

I apologize, but I'm currently unable to retrieve Sam Altman's tweets. It appears there's an authentication limitation with the Twitter/X API.

If you'd like to see Sam Altman's recent tweets, I recommend:

1. Visiting his Twitter/X profile directly at twitter.com/sama
2. Or if you're interested in specific information about Sam Altman or OpenAI, I could help you search for news or other information about him using alternative sources.

Would you like me to try another approach to get information about Sam Altman's recent activities?

🫴🏼 **Takeaway**: Claude tried the `get_recent_tweets` call, and when it failed to get a response, it used reasoning to figure out that it needs to verify the user’s handle by calling the `get_twitter_users` tool. And, then when it got a 403 Forbidden status, it determined that the account has a authentication limitation.

👉🏼 This capability to reason and then automatically choose a different path and other tools, is the main highlight of agentic AI systems.

> **Note**: To use the full potential of MCP servers on Claude, you need the Claude Pro plan at $20/month.

## Conclusion

Although, this article was more about setting up Agent.ai MCP Server with Claude, and give you a taste of running some queries, but you can see despite the limitations of the Claude Free Plan, the applications of this technology is limitless.

The Model Context Protocol (MCP) represents a significant advancement in AI-tool integration, allowing Large Language Models like Claude to interact seamlessly with external services. 

This article detailed the setup process for the Agent.ai MCP Server with Claude Desktop, covering essential steps from obtaining an API key to configuring the server using either NPX or Docker options. It also addressed common issues users might encounter, such as network connection problems and quota limitations on the free plan.

Key takeaways include the importance of proper configuration, the availability of developer mode for troubleshooting, and the understanding that full MCP functionality requires a Claude Pro subscription. 

The article highlighted how Claude can intelligently switch between different tools to provide accurate responses, showcasing the practical benefits of MCP integration in enhancing AI capabilities in limitless use cases.

If you have questions or feedback, please let me know in the comments below.

