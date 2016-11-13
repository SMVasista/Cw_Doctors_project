#python program to generate mutations cluster for responsive and non-resposive patients

from __future__ import division
from sys import argv
import math as mt
import random as rand
import urllib

#Creating Global List Gene_Score which holds all the genes's final values
gene_score = {}
combination_2d = {}
combination_3d = {}

def reflex(value):
	if value == 'R':
		return 'N'
	if value == 'N':
		return 'R'
	if value =='GOF':
		return 'LOF'
	if value == 'LOF':
		return 'GOF'

class patient:
	def __init__(self):
		self.type = None
		self.response = None

	def source_mutation(self, a_list):
		gene = [gene.split(',')[0] for gene in open(a_list)]
		mut = [mut.split(',')[1] for mut in open(a_list)]
		disease = dict(zip(gene, mut))
		self.mutations = {}
		for pert in gene:
			if pert == 'response':
				if disease[pert] == 'R\n':
					self.response = 'R'
				elif disease[pert] == 'N\n':
					self.response = 'N'
			else:
				if disease[pert] == 'OE' or disease[pert] == 'OE\n':
					self.mutations[pert] = 'GOF'
				elif disease[pert] == 'KD' or disease[pert] == 'KD\n':
					self.mutations[pert] = 'LOF'

	def genecluster_1d(self):
			for key in self.mutations:
				if self.mutations[key] == 'GOF' and self.response == 'R':
					if key in gene_score:
						gene_score[key] += 1
					else:
						gene_score[key] = 0
						gene_score[key] += 1
				elif self.mutations[key] == 'LOF' and self.response == 'R':
					if key in gene_score:
						gene_score[key] += -1
					else:
						gene_score[key] = 0
						gene_score[key] += -1
				elif self.mutations[key] == 'GOF' and self.response == 'N':
					if key in gene_score:
						gene_score[key] += -1
					else:
						gene_score[key] = 0
						gene_score[key] += -1
				elif self.mutations[key] == 'LOF' and self.response == 'N':
					if key in gene_score:
						gene_score[key] += 1
					else:
						gene_score[key] = 0
						gene_score[key] += 1

	def genecluster_2d(self):
		for key in self.mutations:
			for key2 in self.mutations:
				if key != key2:
					dimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+"-"+str(self.response)
					dimer_reflex = str(key)+"-"+str(reflex(self.mutations[key]))+","+str(key2)+"-"+str(reflex(self.mutations[key2]))+"-"+str(reflex(self.response))
					
					if dimer in combination_2d: 
						combination_2d[dimer] += 1
					else:
						combination_2d[dimer] = 0
						combination_2d[dimer] += 1
					
	def genecluster_3d(self):
		for key in self.mutations:
			for key2 in self.mutations:
				for key3 in self.mutations:
					if key != key2 and key2 != key3 and key3 != key:
						trimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+","+str(key3)+"-"+str(self.mutations[key3])+"-"+str(self.response)
#						trimer_reflex = str(key)+"-"+str(reflex(self.mutations[key]))+","+str(key2)+"-"+str(reflex(self.mutations[key2]))+","+str(key3)+"-"+str(reflex(self.mutations[key3]))+"-"+str(reflex(self.response))
						if trimer in combination_3d: 
							combination_3d[trimer] += 1
						else:
							combination_3d[trimer] = 0
							combination_3d[trimer] += 1

if __name__ == "__main__":
	script, patientids = argv
	patientids = [patientids.rstrip('\n') for patientids in open(patientids)]
	for patientid in patientids:
		file_loc = str("./"+patientid)
		patientid = patient()
		patientid.source_mutation(file_loc)
		patientid.genecluster_1d()
		patientid.genecluster_2d()
		patientid.genecluster_3d()
	print "Finished analyzing patients"
	number_of_patients = int(len(patientids))
	for key in gene_score:
		if gene_score[key] > 1 or gene_score[key] < -1:
			print key, gene_score[key]
			print ",,mutation_frequency: ", float((gene_score[key] / number_of_patients)*100) 
	for key in combination_2d:
		if combination_2d[key] > 1:
			print key, combination_2d[key]
			print ",,Combination_frequency: ", float((combination_2d[key] / number_of_patients)*100)
	for key in combination_3d:
		if combination_3d[key] > 1:
			print key, combination_3d[key]
			print ",,Combination_frequency: ", float((combination_3d[key] / number_of_patients)*100)

