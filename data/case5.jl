# Data for 5-node distribution system

# Bus data
bus_header = (:bus_i, :type, :Pd, :Qd, :Gs, :Bs, :area, :Vm, :Va, :baseKV, :zone, :Vmax, :Vmin)
bus_data = [
1	2	0	0	0	0	1	1	2.80377	23	1	1.1	    0.90000;
2	1	300	98.61	0	0	1	1.08407	-0.73465	23	1	1.1	    0.90000;
3	0	300	98.61	0	0	1	1	-0.55972	23	1	1.1	    0.90000;
4	3	400	131.47	0	0	1	1	0	23	1	1.1	    0.90000;
5	2	300	98.61	0	0	1	1	3.59033	23	1	1.1	    0.90000;
];

# Generator data
gen_header = (:bus, :Pg, :Qg, :Qmax, :Qmin, :Vg, :mBase, :status, :Pmax, :Pmin, :Rup, :Rdn)
gen_data = [
1	170	127.5	127.5	-127.5	1.07762	100	1	170	0	200	200;
3	324.498	390	400	-400	1.1	100	1	500	0	500	500;
4	0	-10.802	150	-150	1.06414	100	1	400	0	400	400;
5	470.694	-165.039	450	-450	1.06907	600	1	600	0	600	600;
];

# Generator cost data
# Model	startup	shutdown	costfunction: n	c(n-1)	...	c0
gencost_header = (:Model, :startup, :shutdown)
gencost_data = [
	2	0	0	3	0	14	0	   2.000000;
	2	0	0	3	0	15	0	   2.000000;
	2	0	0	3	0	30	0	   2.000000;
	2	0	0	3	0	40	0	   2.000000;
	2	0	0	3	0	10	0	   2.000000;
	2	0	0	3	0.1	0	0	   2.000000;
	2	0	0	3	0.1	0	0	   2.000000;
	2	0	0	3	0.1	0	0	   2.000000;
	2	0	0	3	0.1	0	0	   2.000000;
	2	0	0	3	0.1	0	0	   2.000000;
];

# branch data
branch_header = (:fbus, :tbus, :r, :x, :b, :rateA, :rateB, :rateC, :ratio, :angle, :status, :angmin, :angmax)
branch_data = [
1	2	0.00281	0.0281	0.00712	3	3	3	0	0	1	-30	 30.0;
2	5	0.00304	0.0304	0.00658	3	3	3	0	0	1	-30	 30.0;
2	3	0.00108	0.0108	0.01852	3	3	3	0	0	1	-30	 30.0;
3	4	0.00297	0.0297	0.00674	3	3	3	0	0	1	-30	 30.0;
];

# storage data
storage_header = (:strg_bus, :ps, :qs, :energy, :energy_rat, :charge_rat,  :discharge_rat,  :charge_eff,  :discharge_eff,  :thermal_rating,  :qmin,  :qmax,  :r,  :x,  :p_loss,  :q_loss,  :status)
storage_data = [
	3	0	0	20 100	50	70	0.8	0.9	100	-50	70	0.1	0	0	0	 1;
	5	0	0	30 100	50	70	0.9	0.8	100	-50	70	0.1	0	0	0	 1;
];
