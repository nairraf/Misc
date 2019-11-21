from datetime import datetime

iterations = 100000

def getRunTime(startDate, endDate):
    runtime_seconds = (endDate - startDate).seconds
    runtime_microseconds = (endDate - startDate).microseconds
    days = divmod(runtime_seconds, 86400) # returns a tupple, quotient [0] and remainder [1], we use the remainder of each to calcutate the next level down
    hours = divmod(days[1], 3600)
    minutes = divmod(hours[1], 60)
    seconds = divmod(minutes[1], 1)

    print("    Elapsed Time (d,h,m,s.us): {}:{}:{}:{}.{}".format(int(days[0]), int(hours[0]), int(minutes[0]), seconds[0], runtime_microseconds))


print()
print("Test: Get Current Date")
start = datetime.now()
for i in range(0,iterations):
    test = i
    datetime.now()
    if test % 10000 == 0:
        print(test)

end = datetime.now()
getRunTime(start, end)

print()
print("Test: Dynamic Array Resize")
start = datetime.now()
test_list = []
for i in range(0,iterations):
    test_list.append(i)
    if i % 10000 == 0:
        print(i)
end = datetime.now()
getRunTime(start, end)