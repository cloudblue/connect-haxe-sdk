import os

# def curl():
#    import subprocess

if __name__ == '__main__':
    print('cwd: ' + os.getcwd())
    print('mvn_user: ' + os.environ['mvn_user'])
    print('mvn_password: ' + os.environ['mvn_password'])
