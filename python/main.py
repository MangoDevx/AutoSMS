#!/usr/bin/env python3
import asyncio
import websockets
from chatbot.chatbot import execute_chatbot as exec_cbot

async def server(websocket, path):
    while True:
        data = await websocket.recv()
        print('Data received: '+data)
        result = exec_cbot(data)
        await websocket.send('Reply: '+result)

ADDRESS = "192.168.1.8"
socket_server = websockets.serve(server, ADDRESS, 6789)
print("Waiting for incoming data...")
asyncio.get_event_loop().run_until_complete(socket_server)
asyncio.get_event_loop().run_forever()