#!/usr/bin/env python3

import asyncio
import websockets

async def server(websocket, path):
    data = await websocket.recv()
    print("Received data: "+data)
    await websocket.send("Data received: " + data)

socket_server = websockets.serve(server, "localhost", 6789)
print("Waiting for incoming data...")
asyncio.get_event_loop().run_until_complete(socket_server)
asyncio.get_event_loop().run_forever()