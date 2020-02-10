# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

# This script will push a tag to the main repository whenever a push to master has been made
# and the value in the VERSION file does not match any tag in the repository.
# In response to that push, Travis will relaunch and deploy all packages.
import os


def remove_origin() -> None:
    run(['git', 'remote', 'rm', 'origin'])


def add_origin(token: str) -> None:
    run([
        'git', 'remote', 'add', 'origin',
        'https://cloudblue:{}@github.com/cloudblue/connect-haxe-sdk.git'.format(token)
    ])
    pass


def get_tags() -> list:
    result = run(['git', 'tag']).split('\n')
    return list(filter(lambda x: x != '', result))


def push_tag(tag: str) -> None:
    run(['git', 'tag', tag])
    run(['git', 'push', 'origin', tag])


def run(args: list) -> str:
    import subprocess
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


if __name__ == '__main__':
    print('*** ' + os.environ('TRAVIS_BRANCH'))
    if os.environ('TRAVIS_BRANCH') == 'master':
        remove_origin()
        add_origin(os.environ('doc_token'))
        tags = get_tags()
        with open('VERSION') as f:
            version = 'v' + f.read().strip()
        if version not in tags:
            push_tag(version)
