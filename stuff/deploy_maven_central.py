# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

def curl(path: str, method: str, data: str, content_type: str = 'application/xml') -> str:
    import os
    import subprocess
    user = os.environ['mvn_user']
    password = os.environ['mvn_password']
    base_url = 'https://oss.sonatype.org/service/local/staging/profiles'
    profile_id = 'JaviCerveraIngram'
    args = [
        'curl',
        '-s',
        '-X', method.upper(),
        '-d', data,
        '-u', '{}:{}'.format(user, password),
        '-H', 'Content-Type:{}'.format(content_type),
        '{}/{}/{}'.format(base_url, profile_id, path)
    ]
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


def parse_xml(content: str) -> object:
    from xml.etree import ElementTree
    return ElementTree.fromstring(content)


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
    response = curl('start', 'post', data)
    root = parse_xml(response)
    if root.tag != 'nexus-error':
        return root \
            .find('promoteResponse') \
            .find('data') \
            .find('stagedRepositoryId') \
            .text
    else:
        text = root \
            .find('errors') \
            .find('error') \
            .find('msg') \
            .text
        raise Exception(text)


def upload(repository_id, filename: str) -> str:
    pass


def close() -> str:
    pass


def release() -> str:
    pass


if __name__ == '__main__':
    repository_id = start()
    upload(repository_id, '_build/java/connect.sdk-18.0.jar')
    upload(repository_id, '_build/java/connect.sdk-18.0.pom')
    upload(repository_id, '_build/java/connect.sdk-18.0-sources.jar')
    upload(repository_id, '_build/java/connect.sdk-18.0-javadoc.jar')
    close()
    release()
