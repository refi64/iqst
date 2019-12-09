lambda d,n:(l:=[*__import__('calendar').day_name])[(n+l.index(d))%len(l)]

print((lambda d,n:(l:=[*__import__('calendar').day_name])[(n+l.index(d))%len(l)])('Sunday', 4))

import locale; locale.setlocale(locale.LC_ALL, 'ja_JP.UTF-8')
print((lambda d,n:(l:=[*__import__('calendar').day_name])[(n+l.index(d))%len(l)])('火曜日',4))
