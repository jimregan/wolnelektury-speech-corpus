import textgrid
import sys

tg = textgrid.TextGrid.fromFile('akslop.TextGrid')
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

