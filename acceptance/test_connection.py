#!/usr/bin/env python

import helpers
import random
import sys
import unittest

class ConnectionTest(helpers.MozzoniTest):
    def test_ping(self):
        self.r.ping()

    def test_echo(self):
        self.assertEqual('test',
                self.r.echo('test'))

        self.assertEqual('hello world',
                self.r.echo('hello world'))

if __name__ == '__main__':
    random.seed()
    unittest.main()
