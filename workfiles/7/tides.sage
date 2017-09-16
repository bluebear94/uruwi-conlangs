# How many values to output

limit = int(sys.argv[1]) if len(sys.argv) > 1 else 1000

# :P

tau = 2 * pi

t = var("t")

# Constants

A_s = 0.675; A_sa = 0.0532; A_m = 1.267; A_ma = 0.176; l_m = 30.80152

# Solar component
y_s2 = A_s * (1 + A_sa * cos(tau * t)) * cos(2 * tau * t)
# Lunar component
y_m2 = A_m * (1 + A_ma * cos(tau * t / l_m)) * cos(2 * tau * t / l_m - 2 * tau * t)
y = y_s2 + y_m2
yp = diff(y, t)

# High and low tides occur at values of t where dy/dt = 0.

i = 0
time = 0
print(0)
while i < limit:
  try:
    time2 = find_root(yp == 0, time + 0.000000001, time + 0.35)
    print(time2)
    time = time2
    i += 1
  except:
    time += 0.01
