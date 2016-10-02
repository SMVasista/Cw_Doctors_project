#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import requests
import sys
from bs4 import BeautifulSoup

def parse(linklist):
	
	# Extracting lists into "list"
	links = [links.rstrip('\n') for links in open(linklist)]

	N = len(links)

	for index, link in enumerate(links):
		print "{} of {}: Link: {}".format(index+1, N, link)
		html = requests.get(link).text 				# Request by python to open to page (Internet connection required here)
		data = BeautifulSoup(html, 'html.parser')		# bs will "crawl" the opened page
		print data.get_text().encode('utf-8')

def lookuplinks(linklist):
	
	# Extracting lists into "list"
	links = [links.rstrip('\n') for links in open(linklist)]

	N = len(links)

	for index, link in enumerate(links):
		print "{} of {}: Link: {}".format(index+1, N, link)
		html = requests.get(link).text 				# Request by python to open to page (Internet connection required here)
		data = BeautifulSoup(html, 'html.parser')		# bs will "crawl" the opened page		
		links = data.findAll('a')
		string = "find-a-doctor"
		for b in links:
			if string in b:				
				print b

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print "Usage: {} <link-list>".format(sys.argv[0])
		# NZEC for chaining
		sys.exit(-1)

	lookuplinks(sys.argv[1])
