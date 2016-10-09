# -*- coding: utf-8 -*-

import re
import requests
import sys
import nltk 
from bs4 import BeautifulSoup

caps = "([A-Z])"
prefixes = "(Mr|St|Mrs|Ms|Dr)[.]"
suffixes = "(Inc|Ltd|Jr|Sr|Co)"
starters = "(Mr|Mrs|Ms|Dr|He\s|She\s|It\s|They\s|Their\s|Our\s|We\s|But\s|However\s|That\s|This\s|Wherever)"
acronyms = "([A-Z][.][A-Z][.](?:[A-Z][.])?)"
websites = "[.](com|net|org|io|gov)"

def split_into_sentences(text):
    text = " " + text + "  "
    text = text.replace("\n"," ")
    text = re.sub(prefixes,"\\1<prd>",text)
    text = re.sub(websites,"<prd>\\1",text)
    if "Ph.D" in text: text = text.replace("Ph.D.","Ph<prd>D<prd>")
    if '\n\n' in text: text = text.replace('\n\n','\n')
    if "View on Google Maps" in text: text = text.replace("View on Google Maps","")
    text = re.sub("\s" + caps + "[.] "," \\1<prd> ",text)
    text = re.sub(acronyms+" "+starters,"\\1<stop> \\2",text)
    text = re.sub(caps + "[.]" + caps + "[.]" + caps + "[.]","\\1<prd>\\2<prd>\\3<prd>",text)
    text = re.sub(caps + "[.]" + caps + "[.]","\\1<prd>\\2<prd>",text)
    text = re.sub(" "+suffixes+"[.] "+starters," \\1<stop> \\2",text)
    text = re.sub(" "+suffixes+"[.]"," \\1<prd>",text)
    text = re.sub(" " + caps + "[.]"," \\1<prd>",text)
    if "”" in text: text = text.replace(".”","”.")
    if "\"" in text: text = text.replace(".\"","\".")
    if "!" in text: text = text.replace("!\"","\"!")
    if "?" in text: text = text.replace("?\"","\"?")
    text = text.replace(".",".<stop>")
    text = text.replace("?","?<stop>")
    text = text.replace("!","!<stop>")
    text = text.replace("<prd>",".")
    sentences = text.split("<stop>")
    sentences = sentences[:-1]
    sentences = [s.strip() for s in sentences]
    return sentences

def get_web_data(link):
	# Extracting lists into "list"
	html = requests.get(link).text 				# Request by python to open to page (Internet connection required here)
	data = BeautifulSoup(html, 'html.parser')		# bs will "crawl" the opened page
	print data.get_text().encode('utf-8')

def get_file_data(link):
	# Extracting lists into "list"
	target = open(link, 'r+')
	data = BeautifulSoup(target, 'html.parser')		# bs will "crawl" the opened page
	return data.get_text().encode('utf-8')
	target.close()


if __name__ == '__main__':
	if len(sys.argv) != 2:
		print "Usage: {} <link-list>".format(sys.argv[0])
		# NZEC for chaining
	a = get_file_data(sys.argv[1])
	print a
