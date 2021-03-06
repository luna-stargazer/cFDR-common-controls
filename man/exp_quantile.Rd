% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cFDR.R
\name{exp_quantile}
\alias{exp_quantile}
\title{exp_quantile}
\usage{
exp_quantile(p, pc, rho, method = 1, pi0 = 0.5, sigma = 1,
  dist = rbind((1:10)/10, dnorm((1:10)/10, sd = 3)))
}
\arguments{
\item{p}{Observed p value or set of p values for principal phenotype}

\item{pc}{Observed p value or set of p values for conditional phenotype. Must be of the same length as \code{\link{p}}.}

\item{rho}{Correlation between z values induced by shared controls}

\item{method}{Set to 1 to assume Z scores for the conditional phenotype follow a mixed distribution characterised by \code{\link{pi0}}, \code{\link{sigma}}; 2 to specify assume they follow empirical distribution characterised by \code{\link{dist}}.}

\item{pi0}{Relevant only if \code{\link{method}} = 1. Parameter for distribution of Z scores for the conditional phenotype (proportion of SNPs null for conditional phenotype).}

\item{sigma}{Relevant only if \code{\link{method}} = 1. Parameter for distribution of Z scores for the conditional phenotype (variance of true effect sizes for SNPs non-null for conditional phenotype).}

\item{dist}{Relevant only if \code{\link{method}} = 2. Matrix with two rows; first is a list of potential values for Z scores for conditional phenotype, second is a list of probabilities associated with those values.}
}
\value{
A list of transformed p values (expected quantiles) of the same length as \code{\link{p}}.
}
\description{
Transform principal p-values for estimating cFDR in a shared control design. Computes the 'expected quantile' of a p value.
}
\details{
Computes the probability that a p value at some SNP for a phenotype \eqn{i} is less than some cutoff \eqn{p_{i}}{p_i} given that the p value at that SNP for a second phenotype \eqn{j} is less than a cutoff \eqn{p_{j}}{p_j}, under the null hypothesis that the SNP is not associated with phenotype \eqn{i}.

If the GWAS for phenotypes \eqn{i} and \eqn{j} share a number of controls, effect sizes for the two phenotypes will be correlated, even at null SNPs. This leads to dependence of the expected quantile both on the number of shared controls and study sizes (through paramter \code{\link{rho}}), and the distribution of Z values for phenotype \eqn{j} across all SNPs, not all of which will necessarily be null for phenotype \eqn{j}.

The distribution of Z scores for phenotype \eqn{j} can be specified in two ways, depending on the parameter method. In the first case, we assume that the distribution of 'true' Z scores (Z scores which we would observe if the observed allele frequencies exactly matched the population allele frequencies) has a mixture distribution of 0 with probability \code{\link{pi0}}, and N(0,\code{\link{sigma}}^2) with probability 1-\code{\link{pi0}}. These parameters can be estimated from an observed distribution of Z scores using the function \code{\link{fit.em}} .

In the second case, the distribution of true Z scores can be specified as an array of Z scores and corresponding probabilities (or PDF heights).
}
\examples{
p <- 0.2; pc <- 0.1;
rho <- 0.25
sigma <- 5; pi0 <- 0.95
exp_quantile(p,pc,rho,method=1,pi0=pi0,sigma=sigma)
# Generally the expected quantile is close to p. In this case, the SNP is 'probably' null for phenotype j, so the MAF in controls is somewhat aberrant from expected (as pc<0.1). This means that the expected quantile is higher than the p value.

p<-0.2; pc <-1e-8;
exp_quantile(p,pc,rho,method=1,pi0=pi0,sigma=sigma)
# If a low value of pc is observed, it is 'likely' to have arisen from a non-null SNP for phenotype j. This p value is quite reasonable for a non-null SNP, given the distribution of z values for such SNPs (sigma=5), so the aberration from expected MAF amongst controls is minimal.

pi0=1
exp_quantile(p,pc,rho,method=1,pi0=pi0,sigma=sigma)
# If, on the other hand, pi0=1 (no non-null SNPs for phenotype j), and we happen to observe a p value of 1e-8 for the conditional phenotype, we conclude that MAF in controls is likely to be very aberrant from expected, so the expected quantile is markedly higher than the p value.

rho <- 0
exp_quantile(p,pc,rho,method=1,pi0=pi0,sigma=sigma)
# If rho=0 (no shared controls) z values for the two phenotypes are independent, and the expected quantile equals parameter p.

p3 = rbind((-500:500)/20, dnorm((-500:500)/20,sd=3))
exp_quantile(5e-4,5e-3,0.3,method=2,pi0=0.9,dist=p3)
exp_quantile(5e-4,5e-3,0.3,method=1,pi0=0.9,sigma=3)
# Demonstrates specification of an empirical distribution for Z scores for the conditional phenotype.


}
\author{
James Liley
}

