# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

import os


def curl(path: str, method: str, data: str) -> str:
    import os
    import subprocess
    user = os.environ['mvn_user']
    password = os.environ['mvn_password']
    base_url = 'https://oss.sonatype.org/service/local/staging/profiles'
    profile_id = 'JaviCerveraIngram'
    args = [
        'curl',
        '-X', method.upper(),
        '-d', data,
        '-u', '{}:{}'.format(user, password),
        '-H', 'Content-Type:application/xml',
        '{}/{}/{}'.format(base_url, profile_id, path)
    ]
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


def start() -> str:
    data = """
    <promoteRequest>
        <data>
            <description>
                connect.sdk upload
            </description>
        </data>
    </promoteRequest>
    """
    return curl('start', 'post', data)


if __name__ == '__main__':
    print('Output: ' + start())
