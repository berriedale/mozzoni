#!/usr/bin/env python

import helpers

class PingTest(helpers.MozzoniTest):
    def test_ping(self):
        self.r.ping()

if __name__ == '__main__':
    unittest.main()
