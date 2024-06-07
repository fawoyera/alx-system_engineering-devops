#!/usr/bin/python3
"""
    Module to fetch data from an API and export to JSON file
"""
import csv
import json
import requests
import sys


def run():
    """Function to fetch data from JSONPlaceholder API"""
    # test if employee ID supplied is an integer
    try:
        int(sys.argv[1])
    except (ValueError, IndexError):
        print(f"Usage: python3 {sys.argv[0]} <employee ID>")
        exit(1)

    # fetch the todos for given employee ID
    URL = f'https://jsonplaceholder.typicode.com/users/{sys.argv[1]}/todos'

    response_todos = requests.get(URL)
    if response_todos.status_code == 200:
        data = response_todos.json()

    # fetch the username for the given employee ID
    URL_user = 'https://jsonplaceholder.typicode.com/users'

    response_user = requests.get(URL_user)
    if response_user.status_code == 200:
        users = response_user.json()

    USERNAME = [user.get('username') for user in users
                if user.get('id') == eval(sys.argv[1])][0]
    USER_ID = sys.argv[1]

    todo_list = []
    for todo in data:
        todo_list.append({"task": todo.get('title'),
                          "completed": todo.get('completed'),
                          "username": USERNAME})

    todo_dict = {f"{USER_ID}": todo_list}

    with open(f'{USER_ID}.json', 'w') as json_file:
        json.dump(todo_dict, json_file)


if __name__ == "__main__":
    run()
