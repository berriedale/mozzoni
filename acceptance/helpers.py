import redis
import subprocess
import time
import unittest

class MozzoniTest(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.server = subprocess.Popen(['./obj/mozzoni-daemon'])
        time.sleep(1)
        self.r = redis.Redis(host='localhost',
                port=6379,
                db=0,
                socket_timeout=5)

    @classmethod
    def tearDownClass(self):
        if self.server:
            self.server.terminate()

if __name__ == '__main__':
    print('helpers.py is not meant to be run on its own')
