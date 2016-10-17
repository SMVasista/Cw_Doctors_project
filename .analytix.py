# -*- coding: utf-8 -*-

import re
import requests
from sys import argv
import nltk 

def create2dmatrix(data,q1,q2):
	data = [data.rstrip('\n') for data in open(data)]
	q1list = [q1list.rstrip('\n') for q1list in open(q1)]
	q2list = [q2list.rstrip('\n') for q2list in open(q2)]
	for line in data:
		for query in q1list:
			for query2 in q2list:
				if query in line and query2 in line:
					print query, "&", query2

def create3dmatrix(data,q1,q2,q3):
	data = [data.rstrip('\n') for data in open(data)]
	q1list = [q1list.rstrip('\n') for q1list in open(q1)]
	q2list = [q2list.rstrip('\n') for q2list in open(q2)]
	q3list = [q3list.rstrip('\n') for q2list in open(q3)]
	for line in data:
		for query in q1list:
			for query2 in q2list:
				for query3 in q3list:
					if query in line and query2 in line and query3 in line:
						print query, "&", query2, "in", query3

def create1dmatrix(data,q1):
	data = [data.rstrip('\n') for data in open(data)]
	q1list = [q1list.rstrip('\n') for q1list in open(q1)]
	for line in data:
		for query in q1list:
			if query in line and query2 in line:
				print query


script, option, data, q1, q2, q3 = argv

if option == "2d":
	y = create2dmatrix(data,q1,q2)
	print y
elif option == "3d":
	y = create3dmatrix(data,q1,q2,q3)
	print y
elif option == "1d":
	y = create1dmatrix(data,q1)
	print y
else:
	print "Invalide Option | create [1D] [2D] [3D] co-relation maps"


