days:`Sunday`Monday`Tuesday`Wednesday`Thursday`Friday`Saturday
dayoffset:{days@7 mod y+days?`n$x}
/ 1-liner
d1:{$d@7 mod y+(d:$`Sunday`Monday`Tuesday`Wednesday`Thursday`Friday`Saturday)?x}
d1:{$d@7 mod y+(d:,[;"day"]'$`Sun`Mon`Tues`Wednes`Thurs`Fri`Satur)?x}
