#python program to generate mutations cluster for responsive and non-resposive patients

from __future__ import division
from collections import Counter
from sys import argv
import math as mt
import random as rand

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
		gene = [gene.split(',')[1] for gene in open(a_list)]
		mut = [mut.split(',')[2] for mut in open(a_list)]
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

	def genecluster_1d(self, adict):
			for key in self.mutations:
				if self.mutations[key] == 'GOF' and self.response == 'R':
					if key in adict:
						adict[key] += 1
					else:
						adict[key] = 0
						adict[key] += 1
				elif self.mutations[key] == 'LOF' and self.response == 'R':
					if key in adict:
						adict[key] += -0.5
					else:
						adict[key] = 0
						adict[key] += -0.5
				elif self.mutations[key] == 'GOF' and self.response == 'N':
					if key in adict:
						adict[key] += -0.5
					else:
						adict[key] = 0
						adict[key] += -0.5
				elif self.mutations[key] == 'LOF' and self.response == 'N':
					if key in adict:
						adict[key] += 1
					else:
						adict[key] = 0
						adict[key] += 1

	def genecluster_2d(self, adict):
		for key in self.mutations:
			for key2 in self.mutations:
				if key == key2:
					break
				else:
					dimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+"-"+str(self.response)
					dimer_reflex = str(key)+"-"+str(reflex(self.mutations[key]))+","+str(key2)+"-"+str(reflex(self.mutations[key2]))+"-"+str(reflex(self.response))
					
					if dimer in adict: 
						adict[dimer] += 1
#						adict[dimer_reflex] += 1
					else:
						adict[dimer] = 0
						adict[dimer] += 1
#						adict[dimer_reflex] += 1
					
	def genecluster_3d(self, adict):
		for key in self.mutations:
			for key2 in self.mutations:
				for key3 in self.mutations:
					if key == key2 or key2 == key3 or key3 == key:
						break
					else:
						trimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+","+str(key3)+"-"+str(self.mutations[key3])+"-"+str(self.response)
						trimer_reflex = str(key)+"-"+str(reflex(self.mutations[key]))+","+str(key2)+"-"+str(reflex(self.mutations[key2]))+","+str(key3)+"-"+str(reflex(self.mutations[key3]))+"-"+str(reflex(self.response))

						if trimer in adict: 
							adict[trimer] += 1
						else:
							adict[trimer] = 0
							adict[trimer] += 1
#							adict[trimer_reflex] += 1

if __name__ == "__main__":
	script, patientids = argv
	patientids = [patientids.rstrip('\n') for patientids in open(patientids)]
	number_of_patients = int(len(patientids))
	threshold = number_of_patients/15
	for patientid in patientids:
		file_loc = str("./"+patientid)
		patientid = patient()
		patientid.source_mutation(file_loc)
		if len(patientid.mutations) <= 350:
			patientid.genecluster_1d(gene_score)
			patientid.genecluster_2d(combination_2d)
			patientid.genecluster_3d(combination_3d)
		else:
			patientid.genecluster_1d(gene_score)
			patientid.genecluster_2d(combination_2d)
#			print "3D clustering skipped for", file_loc
#		print "Finished extracting patient",file_loc
	print "Finished analyzing patients"

	selected_mutations = []
	selected_combinations = []

	for key in gene_score:
		if gene_score[key] >= threshold or gene_score[key] <= int(-1*threshold):
			selected_mutations.append(key)
	for key in combination_2d:
		if combination_2d[key] >= 1:
			selected_combinations.append(key)
	for key in combination_3d:
		if combination_3d[key] >= 1:
			selected_combinations.append(key)

	print "Do you want to predict patient response based on the patient data?"
	nod = raw_input('[Y/n]> ')
	
	if nod == 'Y' or nod == 'y':
		new_patient_combinations = {}
		file_loc = raw_input('Location of patient mutation data: ')
		new_patient = patient()
		new_patient.source_mutation(file_loc)
		new_patient.genecluster_2d(new_patient_combinations)
		new_patient.genecluster_3d(new_patient_combinations)
		for p_mutations in new_patient.mutations:
			if p_mutations in selected_mutations:
				print "identified", p_mutations, new_patient.mutations[p_mutations]
		combinations, value = zip(*new_patient_combinations.items())
		for p_combinations in combinations:
			if p_combinations in selected_combinations:
				print "identfied", p_combinations


