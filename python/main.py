#!/usr/bin/env python3

import asyncio
import websockets

async def server(websocket, path):
    data = await websocket.recv()
    print('Data received: '+data)
    await websocket.send('Feed: '+data)

ADDRESS = "192.168.1.8"
socket_server = websockets.serve(server, ADDRESS, 6789)
print(f'Listening on {ADDRESS}:6789')
asyncio.get_event_loop().run_until_complete(socket_server)
asyncio.get_event_loop().run_forever()