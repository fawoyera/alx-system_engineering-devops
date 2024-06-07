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
    # fetch all employees in the api
    URL_user = 'https://jsonplaceholder.typicode.com/users'

    response_user = requests.get(URL_user)
    if response_user.status_code == 200:
        users = response_user.json()

    # initialize employee data for employees
    employee_data = {}
    for user in users:
        USERNAME = user.get('username')
        USER_ID = user.get('id')

        URL = f'https://jsonplaceholder.typicode.com/users/{USER_ID}/todos'

        response_todos = requests.get(URL)
        if response_todos.status_code == 200:
            data = response_todos.json()

            todo_list = []
            for todo in data:
                todo_list.append({"username": USERNAME,
                                  "task": todo.get('title'),
                                  "completed": todo.get('completed')})

            todo_dict = {f"{USER_ID}": todo_list}

        employee_data.update(todo_dict)

    with open('todo_all_employees.json', 'w') as json_file:
        json.dump(employee_data, json_file)


if __name__ == "__main__":
    run()
