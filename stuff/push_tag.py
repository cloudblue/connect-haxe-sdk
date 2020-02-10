# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

# This script will push a tag to the main repository whenever a push to master has been made
# and the value in the VERSION file does not match any tag in the repository.
# In response to that push, Travis will relaunch and deploy all packages.
import os


def remove_origin() -> str:
    return run(['git', 'remote', 'rm', 'origin'])


def add_origin(token: str) -> str:
    return run([
        'git', 'remote', 'add', 'origin',
        'https://cloudblue:{}@github.com/cloudblue/connect-haxe-sdk.git'.format(token)
    ])


def get_tags() -> list:
    result = run(['git', 'tag']).split('\n')
    return list(filter(lambda x: x != '', result))


def push_tag(tag: str) -> str:
    result = run(['git', 'tag', tag]) + '\n'
    result += run(['git', 'push', 'origin', tag])
    return result


def run(args: list) -> str:
    import subprocess
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


if __name__ == '__main__':
    if os.environ['TRAVIS_BRANCH'] == 'master':
        print(remove_origin())
        print(add_origin(os.environ['doc_token']))
        tags = get_tags()
        with open('VERSION') as f:
            version = 'v' + f.read().strip()
        if version not in tags:
            print(push_tag(version))
        else:
            print('Tag is not being pushed because it already exists.')
    else:
        print('Tag is not being pushed because this commit has been pushed to '
            + os.environ['TRAVIS_BRANCH']
            + ' branch instead of master.')
