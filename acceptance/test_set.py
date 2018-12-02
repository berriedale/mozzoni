#!/usr/bin/env python

import redis
import unittest

class SetTest(unittest.TestCase):
    def setUp(self):
        self.r = redis.Redis(host='localhost',
                port=6379,
                db=0,
                socket_timeout=5)

    def test_set(self):
        self.assertTrue(self.r.set('key', 'value'))
        self.assertEqual(self.r.get('key'), 'value')


if __name__ == '__main__':
    unittest.main()
