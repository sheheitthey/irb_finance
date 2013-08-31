require("calcInterest")
require("tax")

# rent + food + utilities
#MONTHLY_EXPENSES = 1000 + 500 + 100;

IRA_CONTRIBUTION_RATE = 0.10
ESPP_CONTRIBUTION_RATE = 0.15

# per bimonthly paycheck
DENTAL_CONTRIBUTIONS = 3.80
MEDICAL_CONTRIBUTIONS = 24.10
VISION_CONTRIBUTIONS = 0.65
FIXED_PRETAX_CONTRIBUTIONS = DENTAL_CONTRIBUTIONS + MEDICAL_CONTRIBUTIONS +
                             VISION_CONTRIBUTIONS

# per bimonthly paycheck
VPDI_CONTRIBUTIONS = 43.30
FIXED_POSTTAX_CONTRIBUTIONS = VPDI_CONTRIBUTIONS

# per bimonthly paycheck
MYSTERY_DEDUCTIONS = 0

def wageToSalary(wage)
    return 40 * 50 * wage;
end

def salaryToWage(salary)
    return salary / (40 * 50);
end

def monthlyToYearly(amount)
    return 12 * amount;
end

def yearlyToMonthly(amount)
    return amount / 12;
end

def bimonthlyToYearly(amount)
    return 2 * 12 * amount
end

def yearlyToBimonthly(amount)
    return amount / (2 * 12)
end

def preTaxContributions(baseSalary, fixedContributions, iraContributionRate)
    return fixedContributions + iraContributionRate * baseSalary
end

def postTaxContributions(baseSalary, fixedContributions, esppContributionRate)
    return fixedContributions + esppContributionRate * baseSalary
end

#YEARLY_EXPENSES = monthlyToYearly(MONTHLY_EXPENSES);

def preTaxIncome(salary)
    fixedPreTaxContributions = bimonthlyToYearly(FIXED_PRETAX_CONTRIBUTIONS)

    return salary - preTaxContributions(salary, fixedPreTaxContributions,
                                        IRA_CONTRIBUTION_RATE)
end

def netIncome(salary)
    income = preTaxIncome(salary)
    fixedPreTaxContributions = bimonthlyToYearly(FIXED_PRETAX_CONTRIBUTIONS)
    fixedPostTaxContributions = bimonthlyToYearly(FIXED_POSTTAX_CONTRIBUTIONS)

    income -= totalTax(salary,
                       preTaxContributions(salary,
                                           fixedPreTaxContributions,
                                           IRA_CONTRIBUTION_RATE) +
                       MYSTERY_DEDUCTIONS)
    income -= postTaxContributions(salary, fixedPostTaxContributions,
                                   ESPP_CONTRIBUTION_RATE)

    return income
end

def disposableIncome(salary, yearlyExpenses)
    return netIncome(salary) - yearlyExpenses;
end

def netSavings(salary, yearlyExpenses, interestRate, nPeriods)
    deposit = disposableIncome(salary, yearlyExpenses);
    return  calcInterest(interestRate, deposit, nPeriods);
end

def bimonthlyPaycheck(salary)
    return yearlyToBimonthly(netIncome(salary))
end
