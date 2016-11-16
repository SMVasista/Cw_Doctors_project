from __future__ import division
from collections import Counter
from sys import argv

#Patient Training Data
training_gene_score = {}
genes_selected = []
training_combinations_score = {}
combinations_selected = []

class patient:
	def __init__(self):
		self.type = None
		self.response = None

	def source_mutation(self, alist):
		gene = [gene.split(',')[1] for gene in open(alist)]
		mut = [mut.split(',')[2] for mut in open(alist)]
		disease = dict(zip(gene, mut))
		self.mutations = {}
		for pert in gene:
			if pert == 'response':
				if disease[pert] == 'R\n' or disease[pert] == 'R':
					self.response = 'R'
				elif disease[pert] == 'N\n' or disease[pert] == 'N': 
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
						adict[key] = 1
				elif self.mutations[key] == 'LOF' and self.response == 'R':
					if key in adict:
						adict[key] += -0.5
					else:
						adict[key] = -0.5
				elif self.mutations[key] == 'GOF' and self.response == 'N':
					if key in adict:
						adict[key] += -0.5
					else:
						adict[key] = -0.5
				elif self.mutations[key] == 'LOF' and self.response == 'N':
					if key in adict:
						adict[key] += 1
					else:
						adict[key] = 1

	def genecluster_2d(self, adict):
		for key in self.mutations:
			for key2 in self.mutations:
				if key == key2:
					break
				else:
					if self.response != None:
						dimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+"-"+str(self.response)
					
						if dimer in adict: 
							adict[dimer] += 1
						else:
							adict[dimer] = 1
					else:
						for prime in ['R', 'N']:
							dimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+"-"+str(prime)

							if dimer in adict:
								adict[dimer] += 1
							else:
								adict[dimer] = 1


	def genecluster_3d(self, adict):
		for key in self.mutations:
			for key2 in self.mutations:
				for key3 in self.mutations:
					if key == key2 or key2 == key3 or key3 == key:
						break
					else:
						if self.response != None:
							trimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+","+str(key3)+"-"+str(self.mutations[key3])+"-"+str(self.response)

							if trimer in adict: 
								adict[trimer] += 1
							else:
								adict[trimer] = 1
						else:
							for prime in ['R', 'N']:
								trimer = str(key)+"-"+str(self.mutations[key])+","+str(key2)+"-"+str(self.mutations[key2])+","+str(key3)+"-"+str(self.mutations[key3])+"-"+str(prime)

							if trimer in adict: 
								adict[trimer] += 1
							else:
								adict[trimer] = 1
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
			patientid.genecluster_1d(training_gene_score)
			patientid.genecluster_2d(training_combinations_score)
			patientid.genecluster_3d(training_combinations_score)
		else:
			patientid.genecluster_1d(training_gene_score)
			patientid.genecluster_2d(training_combinations_score)
#			print "3D clustering skipped for", file_loc
#		print "Finished extracting patient",file_loc
	print "Finished analyzing patients"
	
	for key in training_gene_score:
		if training_gene_score[key] >= threshold or training_gene_score[key] <= int(-1*threshold):
			genes_selected.append(key)
	for key in training_combinations_score:
		if training_combinations_score[key] >= threshold:
			combinations_selected.append(key)
	for key in training_combinations_score:
		if training_combinations_score[key] > 2:
			combinations_selected.append(key)

	print "Do you want to predict patient response based on the patient data?"
	nod = raw_input('[Y/n]> ')
	
	if nod == 'Y' or nod == 'y':
		new_patient_combinations = {}
		file_loc = raw_input('Location of patient mutation data: ')
		new_patient = patient()
		new_patient.source_mutation(file_loc)
		new_patient.genecluster_2d(new_patient_combinations)
		new_patient.genecluster_3d(new_patient_combinations)
		for keys in genes_selected:
			if keys in new_patient.mutations:
				print "identified", keys, new_patient.mutations[keys]
		
		for keys in combinations_selected:
			if keys in new_patient_combinations:
				print "identified", keys
