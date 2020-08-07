#!/usr/bin/env python
import textgrid
import sys

if len(sys.argv) != 2:
    print("textgrid-to-audacity.py [filename]")
    quit()

tg = textgrid.TextGrid.fromFile(sys.argv[1])
started = False
start=0.0
end=0.0
text=list()
for i in tg[0]:
    if i.mark != '':
        if not started:
            start = i.minTime
            started = True
        else:
            started = True
        end = i.maxTime
        text.append(i.mark)
    else:
        if started:
            print('{}\t{}\t{}'.format(start, end, ' '.join(text)))
            start = 0.0
            end = 0.0
            text.clear()
            started = False

