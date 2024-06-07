#!/usr/bin/python3
"""
    Module to fetch data from an API and export to CSV file
"""
import csv
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

    with open(f'{USER_ID}.csv', 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file, quoting=csv.QUOTE_ALL)
        for todo in data:
            csv_writer.writerow([USER_ID, USERNAME, todo.get('completed'),
                                todo.get('title')])


if __name__ == "__main__":
    run()
