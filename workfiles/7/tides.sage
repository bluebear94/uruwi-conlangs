limit = int(sys.argv[1]) if len(sys.argv) > 1 else 1000

tau = 2 * pi

t = var("t")
A_s = 1.267; A_sa = 0.0532; A_m = 0.675; A_ma = 0.176; l_m = 30.80152

y_s2 = A_s * (1 + A_sa * cos(tau * t)) * cos(2 * tau * t)
y_m2 = A_m * (1 + A_ma * cos(tau * t / l_m)) * cos(2 * tau * t / l_m - 2 * tau * t)
y = y_s2 + y_m2
yp = diff(y, t)

for i in range(0, limit):
  try:
    print(find_root(yp == 0, n(0.25 * i), n(0.25 * (i + 1))))
  except:
    pass
