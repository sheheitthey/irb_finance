#FEDERAL_STANDARD_DEDUCTION = 5700
FEDERAL_STANDARD_DEDUCTION = 0
FEDERAL_PERSONAL_EXEMPTION = 3650  # TODO: This phases out.
FEDERAL_BRACKETS = [ 8375, 34000, 82400, 171850, 373650 ]
FEDERAL_RATES = [ 0.10, 0.15, 0.25, 0.28, 0.33, 0.35 ]

# 2009
#FEDERAL_BRACKETS = [ 8350, 33950, 82250, 171550, 372950 ]
#FEDERAL_RATES = [ 0.10, 0.15, 0.25, 0.28, 0.33, 0.35 ]

SOCIAL_SECURITY_RATE = 0.062
SOCIAL_SECURITY_LIMIT = 106800
MEDICARE_RATE = 0.0145
MEDICARE_LIMIT = nil

CALIFORNIA_STANDARD_DEDUCTION = 3637
CALIFORNIA_PERSONAL_EXEMPTION = 98  # TODO: Does this phase out?
CALIFORNIA_BRACKETS = [ 7060, 16739, 26419, 36675, 46349 ]
CALIFORNIA_RATES = [ 0.0125, 0.0225, 0.0425, 0.0625, 0.0825, 0.0955 ]

#CALIFORNIA_SUI_RATE = 0.062  # anywhere between 1.5% and 6.2%
CALIFORNIA_SUI_RATE = 0.0
CALIFORNIA_SUI_LIMIT = 7000
#CALIFORNIA_SDI_RATE = 0.008
CALIFORNIA_SDI_RATE = 0.0
CALIFORNIA_SDI_LIMIT = 693.58

def totalTax(salary, preIncomeTaxDeductions)
    return federalTax(salary, preIncomeTaxDeductions) +
           stateTax(salary, preIncomeTaxDeductions);
end

def federalTax(salary, preIncomeTaxDeductions)
    taxableIncome = federalTaxableIncome(salary - preIncomeTaxDeductions, 2)
    # TODO: make sure federalPayrollTax is right.
    return federalIncomeTax(taxableIncome) + federalPayrollTax(salary);
end

def stateTax(salary, preIncomeTaxDeductions)
    taxableIncome = stateTaxableIncome(salary - preIncomeTaxDeductions, 2)

    # TODO: Verify this
    return stateIncomeTax(taxableIncome) + statePayrollTax(salary);
end

# Compute federal taxable income from salary.
def federalTaxableIncome(salary, numPersonalExemptions)
    totalDeductions = FEDERAL_STANDARD_DEDUCTION +
                      numPersonalExemptions * FEDERAL_PERSONAL_EXEMPTION
    return incomeAfterDeduction(salary, totalDeductions)
end

# Computes the amount of federal income tax.
def federalIncomeTax(taxableIncome)
    return progressiveTax(FEDERAL_BRACKETS, FEDERAL_RATES, taxableIncome)
end

# Computes the amount of federal payroll tax.
def federalPayrollTax(salary)
    return flatTax(SOCIAL_SECURITY_RATE, SOCIAL_SECURITY_LIMIT, salary) +
           flatTax(MEDICARE_RATE, MEDICARE_LIMIT, salary);
end

# Compute state taxable income from salary.
def stateTaxableIncome(salary, numPersonalExemptions)
    return incomeAfterDeduction(salary, CALIFORNIA_STANDARD_DEDUCTION +
                                numPersonalExemptions *
                                CALIFORNIA_PERSONAL_EXEMPTION)
end

# Computes the amount of state income tax.
def stateIncomeTax(taxableIncome)
    return progressiveTax(CALIFORNIA_BRACKETS, CALIFORNIA_RATES, taxableIncome)
end

# Computes the amount of state payroll tax.
# TODO: Verify that this should take salary, not taxableIncome
def statePayrollTax(salary)
    return flatTax(CALIFORNIA_SUI_RATE, CALIFORNIA_SUI_LIMIT, salary) +
           flatTax(CALIFORNIA_SDI_RATE, CALIFORNIA_SDI_LIMIT, salary);
end

# Computes the effective tax rate on a salary.
def effectiveTaxRate(salary)
    return totalTax(salary) / salary;
end

# Compute the running taxable income after applying a deduction.
def incomeAfterDeduction(salary, deduction)
    return salary - deduction
end

# Computes a progressive tax.
def progressiveTax(brackets, rates, taxableIncome)
    tax = 0.0
    previousBracket = 0.0

    for i in (0..(rates.length() - 1))
        if i < brackets.length() then
            bracket = brackets[i]
        else
            bracket = nil
        end
        rate = rates[i]

        if bracket != nil and taxableIncome >= bracket then
            tax += rate * (bracket - previousBracket)
        else
            tax += rate * (taxableIncome - previousBracket)
            break
        end

        previousBracket = bracket
    end

    return tax
end

# Computes a flat income tax, up to a maximum tax of maxTax.
# TODO: Check whether maxTax or maxTaxableIncome makes more sense.
def flatTax(rate, maxTaxableIncome, taxableIncome)
    income = taxableIncome

    if maxTaxableIncome != nil and income > maxTaxableIncome then
        income = maxTaxableIncome
    end

    return rate * income
#tax = rate * taxableIncome;

#    if maxTax != nil and tax > maxTax then
#        tax = maxTax
#    end

#    return tax
end
