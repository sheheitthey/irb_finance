# Refer annuity.txt for derivations.

# Account balance after starting with principal and growing by periodicRate
# while making a payment of periodicPayment each period for numPeriods.
#
# For example, a savings account typically starts with principal = 0 and
# periodicPayment > 0. A loan typically starts with principal < 0 and
# periodicPayment > 0. periodicPayment < 0 could represent accounts being
# withdrawn from.
def accountBalance(principal, periodicRate, periodicPayment, numPeriods)
    rateFactor = 1.0 + periodicRate

    return (periodicPayment * (1 - rateFactor**numPeriods)) / (1 - rateFactor) +
           rateFactor**numPeriods * principal
end

# Account balance after starting with principal, growing by yearlyRate per year
# while making a payment of monthlyPayment each month for numMonths
def monthlyAccountBalance(principal, yearlyRate, monthlyPayment, numMonths)
    monthlyRate = yearlyRate / 12

    return accountBalance(principal, monthlyRate, monthlyPayment, numMonths)
end

# Amount of interest accrued after starting with principal and growing by
# periodicRate while making a payment of periodicPayment each period for
# numPeriods.
def accountInterest(principal, periodicRate, periodicPayment, numPeriods)
    totalContributed = principal + numPeriods * periodicPayment
    balance = accountBalance(principal, periodicRate,
                             periodicPayment, numPeriods)

    return balance - totalContributed
end

# Amount of interest accrued after starting with principal and growing by
# yearlyRate per year while making a payment of monthlyPayment each month for
# numMonths.
def monthlyAccountInterest(principal, yearlyRate, monthlyPayment, numMonths)
    monthlyRate = yearlyRate / 12

    return accountInterest(principal, monthlyRate, monthlyPayment, numMonths)
end

# Periodic payment required to turn principal (possibly negative) into
# desiredBalance in numPeriods periods while it grows by periodicRate per
# period.
def periodicPayment(principal, periodicRate, desiredBalance, numPeriods)
    rateFactor = 1.0 + periodicRate

    return ((desiredBalance - (rateFactor**numPeriods * principal)) *
            (1 - rateFactor)) / (1 - rateFactor**numPeriods)
end

# Monthly payment required to turn principal (possibly negative) into
# desiredBalance in numYears years while it grows by yearlyRate per year.
def monthlyPayment(principal, yearlyRate, desiredBalance, numYears)
    monthlyRate = yearlyRate / 12
    numMonths = numYears * 12

    return periodicPayment(principal, monthlyRate, desiredBalance, numMonths)
end

# Amount of interest charged after numPeriods periods on a loan of principal
# (which should be negative) at periodicRate rate for termPeriods periods.
def loanInterest(principal, periodicRate, termPeriods, numPeriods)
    payment = periodicPayment(principal, periodicRate, 0.0, termPeriods)

    return accountInterest(principal, periodicRate, payment, numPeriods)
end

# Amount of interest charged after numMonths months on a loan of principal
# (which should be negative) at yearlyRate rate for termYears years.
def monthlyLoanInterest(principal, yearlyRate, termYears, numMonths)
    monthlyRate = yearlyRate / 12
    termMonths = termYears * 12

    return loanInterest(principal, monthlyRate, termMonths, numMonths)
end

# Estimate monthly payment after tax required during first year to pay off
# principal being charged yearlyRate rate in numYears years.
def monthlyPaymentAfterTax(principal, yearlyRate, numYears, taxRate)
    monthlyPaymentBeforeTax = monthlyPayment(principal, yearlyRate, numYears)
    firstYearInterest = monthlyAccountInterest(principal, yearlyRate,
                                               -monthlyPaymentBeforeTax, 1*12)
    firstYearTaxDeduction = taxRate * firstYearInterest

    return monthlyPaymentBeforeTax - (firstYearTaxDeduction / 12)
end
