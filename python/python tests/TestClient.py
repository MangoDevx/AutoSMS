#!/usr/bin/env python3

import asyncio
import websockets
import json

async def client():
    uri = "ws://192.168.1.8:6789"
    while True:
        async with websockets.connect(uri) as websocket:
            value = await asyncio.get_event_loop().run_in_executor(None, lambda: input('Input: '))
            data = json.dumps({"data": value})
            await websocket.send(data)
            response = await websocket.recv()
            print(response)
        
asyncio.get_event_loop().run_until_complete(client())