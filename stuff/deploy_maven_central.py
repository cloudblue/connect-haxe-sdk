# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

# Developed following the instructions here:
# https://support.sonatype.com/hc/en-us/articles/213465868?_ga=2.230043868.1594253912.1579542012-1885361292.1578410493

import os
import time
from xml.etree import ElementTree

with open('VERSION') as f:
    VERSION = f.read().strip()
DEPLOY_URL = 'https://oss.sonatype.org/service/local/staging/deployByRepositoryId'
PROFILES_URL = 'https://oss.sonatype.org/service/local/staging/profiles'
PROFILE_REPOSITORIES_URL = 'https://oss.sonatype.org/service/local/staging/profile_repositories'
PROMOTE_URL = 'https://oss.sonatype.org/service/local/staging/bulk/promote'
MVN_USER = os.environ['mvn_user']
MVN_PASSWORD = os.environ['mvn_password']
MVN_PASSPHRASE = os.environ['mvn_passphrase']
PATH = '_build/java'
FILES = [
    'connect.sdk-{}.jar'.format(VERSION),
    'connect.sdk-{}.pom'.format(VERSION),
    'connect.sdk-{}-sources.jar'.format(VERSION),
    'connect.sdk-{}-javadoc.jar'.format(VERSION)
]
GROUP_ID = ElementTree \
    .parse('/'.join([PATH, FILES[1]])) \
    .getroot() \
    .find('{http://maven.apache.org/POM/4.0.0}groupId') \
    .text


def run(args: list) -> str:
    import subprocess
    return subprocess.run(args, stdout=subprocess.PIPE).stdout.decode('utf-8')


def curl(url: str, method: str, data: str = None, content_type: str = 'application/xml') -> str:
    args = [
        'curl',
        '-s',
        '-u', '{}:{}'.format(MVN_USER, MVN_PASSWORD),
    ]
    if method.lower() == '--upload-file':
        args.extend(['-H', 'Content-Type:application/x-jar'])
        args.extend(['--upload-file', data])
    else:
        args.extend(['-X', method.upper()])
        if data:
            args.extend(['-H', 'Content-Type:' + content_type])
            args.extend(['-d', data])
    args.append(url)
    return run(args)


def xml_error(elem: ElementTree) -> str:
    if elem.tag == 'nexus-error':
        return elem \
            .find('errors') \
            .find('error') \
            .find('msg') \
            .text
    else:
        return None


def start(profile_id: str) -> str:
    print('*** Starting repository...', flush=True)
    data = """
    <promoteRequest>
        <data>
            <description>start</description>
        </data>
    </promoteRequest>
    """
    response = curl('/'.join([PROFILES_URL, profile_id, 'start']), 'post', data)
    root = ElementTree.fromstring(response)
    if root.tag == 'promoteResponse':
        return root \
            .find('data') \
            .find('stagedRepositoryId') \
            .text
    else:
        raise Exception(xml_error(root))


def upload(repository_id: str, filename: str) -> str:
    strip_filename = filename.split('/')[-1]
    dash_split = strip_filename.split('-')
    artifact_id = dash_split[0]
    # Could this be replaced in favor of VERSION now?
    version = '.'.join([s for s in dash_split[1].split('.') if s.isdigit()])
    url_comps = [DEPLOY_URL, repository_id]
    url_comps.extend(GROUP_ID.split('.'))
    url_comps.append(artifact_id)
    url_comps.append(version)
    url_comps.append(strip_filename)
    url = '/'.join(url_comps)
    print('*** Uploading "{}" to "{}"...'.format(filename, url), flush=True)
    response = curl(url, '--upload-file', filename)
    return response


def finish(profile_id: str, repository_id: str) -> str:
    print('*** Closing repository...', flush=True)
    data = """
    <promoteRequest>
        <data>
            <stagedRepositoryId>{}</stagedRepositoryId>
            <description>finish</description>
        </data>
    </promoteRequest>
    """.format(repository_id)
    response = curl('/'.join([PROFILES_URL, profile_id, 'finish']), 'post', data)
    return response


def repository_status(profile_id: str, repository_id: str) -> str:
    print('*** Getting staging repositories...', flush=True)
    response = curl('/'.join([PROFILE_REPOSITORIES_URL, profile_id]), 'get')
    root = ElementTree.fromstring(response)
    if root.tag == 'stagingRepositories':
        data = root.find('data')
        repos = [repo for repo in data if repo.find('repositoryId').text == repository_id]
        return repos[0].find('type').text
    else:
        raise Exception(xml_error(root))


def promote(repository_id: str) -> str:
    print('*** Releasing repository...')
    data = '''
    {
        \"data\": {
            \"stagedRepositoryIds\": [\"''' + repository_id + '''\"],
            \"description\": \"promote\"
        }
    }
    '''
    response = curl(PROMOTE_URL, 'post', data, 'application/json')
    return response


def sign(filename: str) -> str:
    print('*** Signing "' + filename + '"...', flush=True)
    return run(['gpg', '--batch', '--yes', '--passphrase', MVN_PASSPHRASE, '-ab', filename])


def md5(filename: str) -> str:
    print('*** Generating MD5 checksum for file "' + filename + '"...', flush=True)
    import hashlib
    md5 = hashlib.md5()
    with open(filename, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            md5.update(chunk)
    digest = md5.hexdigest()
    with open(filename + '.md5', 'w') as f:
        f.write(digest)
    return digest


def sha1(filename: str) -> str:
    print('*** Generating SHA1 checksum for file "' + filename + '"...', flush=True)
    import hashlib
    with open(filename, 'rb') as f:
        contents = f.read()
    sha1 = hashlib.sha1(contents)
    digest = sha1.hexdigest()
    with open(filename + '.sha1', 'w') as f:
        f.write(digest)
    return digest


def get_profile_id() -> str:
    print('*** Getting profiles...', flush=True)
    response = curl(PROFILES_URL, 'get')
    root = ElementTree.fromstring(response)
    if root.tag == 'stagingProfiles':
        data = root.find('data')
        profiles = [profile for profile in data if profile.find('name').text == GROUP_ID]
        profile_id = profiles[0].find('id').text
        print('*** Found profile id ' + profile_id, flush=True)
        return profile_id
    else:
        raise Exception(xml_error(root))


def upload_files(profile_id: str, repository_id: str) -> None:
    for file in FILES:
        fullname = '/'.join([PATH, file])
        print(upload(repository_id, fullname), flush=True)
        sign(fullname)
        print(upload(repository_id, fullname + '.asc'), flush=True)
        md5(fullname)
        print(upload(repository_id, fullname + '.md5'), flush=True)
        sha1(fullname)
        print(upload(repository_id, fullname + '.sha1'), flush=True)
    print(finish(profile_id, repository_id), flush=True)


def close_repository(profile_id: str, repository_id: str) -> bool:
    print('*** Waiting until the repository is closed...', flush=True)
    max_attempts = 10
    num_attempts = 0
    status = repository_status(profile_id, repository_id)
    while num_attempts < max_attempts and status != 'closed':
        print('*** Repository status is "' + status + '"', flush=True)
        num_attempts += 1
        print('*** Sleeping for 1 minute (retry {}/{})...'.format(num_attempts, max_attempts),
            flush=True)
        time.sleep(60)
        status = repository_status(profile_id, repository_id)
    return status == 'closed'


if __name__ == '__main__':
    profile_id = get_profile_id()
    repository_id = start(profile_id)
    upload_files(profile_id, repository_id)

    # Wait until the repository gets successfully closed
    max_attempts = 5
    num_attempts = 1
    closed = close_repository(profile_id, repository_id)
    while num_attempts < max_attempts and not closed:
        num_attempts += 1
        print('*** Repository could not be closed, retrying... ({}/{})'. \
            format(num_attempts, max_attempts))
        closed = close_repository(profile_id, repository_id)
    if not closed:
        raise Exception('Repository could not be closed.')
    else:
        print('*** Repository closed.')

    print('*** Sleeping for 1 minute...', flush=True)
    time.sleep(60)

    print(promote(repository_id), flush=True)

    print('*** Done.', flush=True)
