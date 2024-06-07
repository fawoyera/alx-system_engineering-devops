#!/usr/bin/python3
"""
    Module to fetch data from an API
"""
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

    # fetch the name for the given employee ID
    URL_user = 'https://jsonplaceholder.typicode.com/users'

    response_user = requests.get(URL_user)
    if response_user.status_code == 200:
        users = response_user.json()

    EMPLOYEE_NAME = [user.get('name') for user in users
                     if user.get('id') == eval(sys.argv[1])][0]
    NUMBER_OF_DONE_TASKS = 0
    TOTAL_NUMBER_OF_TASKS = 0

    for todo in data:
        if todo.get('completed') is True:
            NUMBER_OF_DONE_TASKS += 1
        TOTAL_NUMBER_OF_TASKS += 1

    print(f"Employee {EMPLOYEE_NAME} is done with tasks"
          f"({NUMBER_OF_DONE_TASKS}/{TOTAL_NUMBER_OF_TASKS}):")

    for todo in data:
        if todo.get('completed') is True:
            print(f"\t {todo.get('title')}")


if __name__ == "__main__":
    run()
