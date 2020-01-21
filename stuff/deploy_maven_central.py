# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

import os

profiles_url = 'https://oss.sonatype.org/service/local/staging/profiles'
deploy_url = 'https://oss.sonatype.org/service/local/staging/deployByRepositoryId'
mvn_user = os.environ['mvn_user']
mvn_password = os.environ['mvn_password']
mvn_passphrase = os.environ['mvn_passphrase']
mvn_profile = 'JaviCerveraIngram'


def run(args: list) -> str:
    import subprocess
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


def curl(url: str, method: str, data: str) -> str:
    args = [
        'curl',
        '-s',
        '-u', '{}:{}'.format(mvn_user, mvn_password),
    ]
    if method.lower() == '--upload-file':
        args.extend(['-H', 'Content-Type:application/x-jar'])
        args.extend(['--upload-file', data])
    else:
        args.extend(['-H', 'Content-Type:application/xml'])
        args.extend(['-X', method.upper()])
        args.extend(['-d', data])
    args.append(url)
    return run(args)


def sign(filename: str) -> str:
    return run(['gpg', '--passphrase', mvn_passphrase, '-ab', filename])


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
    response = curl('/'.join([profiles_url, mvn_profile, 'start']), 'post', data)
    root = parse_xml(response)
    if root.tag == 'promoteResponse':
        return root \
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
    path = '_build/java'
    files = [
        'connect.sdk-18.0.jar',
        'connect.sdk-18.0.pom',
        'connect.sdk-18.0-sources.jar',
        'connect.sdk-18.0-javadoc.jar'
    ]

    print('Starting repository...')
    repository_id = start()

    for file in files:
        fullname = '/'.join([path, file])
        ascname = fullname + '.asc'
        print('Uploading "' + fullname + '"...')
        upload(repository_id, fullname)
        print('Signing "' + fullname + '"...')
        sign(fullname)
        print('Uploading "' + ascname + '"...')
        upload(repository_id, ascname)
    
    print('Closing repository...')
    close()

    print('Releasing repository...')
    release()

    print('Done.')
