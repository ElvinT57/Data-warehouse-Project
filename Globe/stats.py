import csv
import math

file = "D:\\Downloads\\archive\\GlobalLandTemperaturesByCountry.csv"
averages = set()


with open(file) as csvFile:
    rows = list(csv.reader(csvFile, delimiter=","))
    rows.pop(0)

    for row in rows:
        if row[1] == '':
            continue
        averages.add(math.trunc(float(row[1])))
averages = sorted(averages)
print(averages)
print("Length: ", len(averages))
