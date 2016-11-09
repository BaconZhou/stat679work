import sys
import re
from operator import itemgetter

arg = sys.argv

with open(arg[1]) as f:
    temperature = [line.rstrip('\n').split(",") for line in f if line.rstrip('\n') != '']

with open(arg[2]) as f:
    energy = [line.rstrip('\n').split(",") for line in f if line.rstrip('\n') != '']


class csvData:

    def __init__(self, filename):
        with open(filename) as f:
            self.data = [line.rstrip('\n').split(",") for line in f if line.rstrip('\n') != '']
        self.start = None
        self.end = None
        for instance in self.data:
            # capture the first element for each line, test wether it is a number
            temp = list(instance[0][0])[0]
            try:
                int(temp)
                index = self.data.index(instance)
                if self.start == None:
                    self.start = index
                self.end = index
            except ValueError:
                pass
        self.head = self.data[:self.start]
        self.end = self.data[(self.end-1):]
        self.data = self.data[self.start:self.end]
        self.match()
        self.reOrder(self.dateIndex)


    def reOrder(self, index):
        self.data = sorted(self.data, key = itemgetter(index))

    def match(self):
        for item in self.data[0]:
            if re.search(r':', item)):
                self.dateIndex = self.data[0].index(item)

def combine(data1, data2):
    data1
