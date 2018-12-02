#!/usr/bin/env python

import redis
import unittest

class PingTest(unittest.TestCase):
    def setUp(self):
        self.r = redis.Redis(host='localhost',
                port=6379,
                db=0,
                socket_timeout=5)

    def test_ping(self):
        self.r.ping()


if __name__ == '__main__':
    unittest.main()
