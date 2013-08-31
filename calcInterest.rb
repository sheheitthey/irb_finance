def simpleInterest(rate, deposit)
    return (1+rate)*deposit;
end

#Calculates total balance after depositing for nPeriods while accumulating interest.
def calcInterest(rate, deposit, nPeriods)
    y = 0;
    for i in (1..nPeriods)
        y = simpleInterest(rate, y + deposit);
    end
    return y;
end

#Calculates total interest after depositing for nPeriods.
def interestProfit(rate, deposit, nPeriods)
    accumulatedDeposit = deposit * nPeriods;
    return calcInterest(rate, deposit, nPeriods) - accumulatedDeposit;
end
