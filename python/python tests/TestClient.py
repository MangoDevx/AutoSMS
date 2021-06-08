#!/usr/bin/env python3

import asyncio
import websockets
import json

async def client():
    uri = "ws://localhost:6789"
    async with websockets.connect(uri) as websocket:
        value = input("Input data:")
        data = json.dumps({"data": value})
        await websocket.send(data)
        
        response = await websocket.recv()
        print(response)
        
asyncio.get_event_loop().run_until_complete(client())