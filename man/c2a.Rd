% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cFDR.R
\name{c2a}
\alias{c2a}
\title{c2a}
\usage{
c2a(P_i, P_j, cutoffs, pi0 = 0.5, sigma = 1, rho = 0, xmax = 12,
  ymax = 12, res = 0.01)
}
\arguments{
\item{P_i}{vector of p-values for the principal phenotype.}

\item{P_j}{vector of p-values or adjusted p-values for the conditional phenotype. If controls are shared between GWAS, the p-values must be adjusted using the function \code{\link{exp_quantile}}.}

\item{cutoffs}{vector of cFDR cutoffs at which to compute overall FDR}

\item{pi0}{proportion of SNPs not associated with conditional phenotype}

\item{sigma}{standard deviation of observed conditional Z scores in SNPs associated with the conditional phenotype}

\item{rho}{covariance between principal and conditional Z scores arising due to shared controls; output from \code{\link{cor_shared}}.}

\item{xmax}{compute integral over [0,\code{\link{xmax}}] x [0,\code{\link{ymax}}] as approximation to [0,inf] x [0,inf]}

\item{ymax}{compute integral over [0,\code{\link{xmax}}] x [0,\code{\link{ymax}}] as approximation to [0,inf] x [0,inf]}

\item{res}{compute integral at gridpoints with this spacing.}

\item{vector}{of FDR values corresponding to \code{\link{cutoffs}}}
}
\value{
list of FDR values
}
\description{
Compute an upper bound on the false discovery rate amongst SNPs with cFDR less than some cutoff \eqn{\alpha} .
}
\details{
Bound is based on estimating the area of the region of the unit square containing all potential p-value pairs \eqn{p_{i},p_{j}}{p_i,p_j} such that \eqn{\widehat{cFDR}(p_{i},p_{j}) \leq \alpha}{est. cFDR(p_i,p_j) \le \alpha}. It is typically conservative.

Computation requires parametrisation of the joint distribution of Z scores for the conditional phenotype at SNPs null for the principal phenotype. This is assumed to be mixture-Gaussian, consisting of N(0,I_2) with probability \code{\link{pi0}} and N(0,(1,rho; rho,\code{\link{sigma}}^2)) with probability 1-\code{\link{pi0}}. Values of \code{\link{pi0}} and \code{\link{sigma}} can be obtained from the fitted parameters of the null model usign the function \code{\link{fit.em}}.

The probability is computed using a numerical integral over the (+/+) quadrant and the range and resolution of the integral can be set.
}
\examples{
nn=100000

Z=abs(rbind(rmnorm(0.8*nn,varcov=diag(2)), rmnorm(0.15*nn,varcov=rbind(c(1,0),c(0,2^2))), rmnorm(0.05*nn,varcov=rbind(c(3^2,2),c(2,4^2)))));
P=2*pnorm(-abs(Z))

X=cfdr(P[,1],P[,2],sub=which(Z[,1]^2 + Z[,2]^2 > 6))
Xm=which(X<0.05); Xsub=Xm[order(runif(length(Xm)))[1:100]] # sample of cFDR values 

true_fdr=rep(0,100); for (i in 1:100) true_fdr[i]=length(which(X[1:(0.95*nn)] <= X[Xsub[i]]))/length(which(X<=X[Xsub[i]])) # true FDR values (empirical)
fdr=c2a(P[,1],P[,2],X[Xsub],pi0=0.95,sigma=2) # estimated FDR using area method

plot(true_fdr,fdr,xlab="True FDR",ylab="Estimated",col="red"); points(true_fdr,X[Xsub],col="blue"); abline(0,1); legend(0.1*max(true_fdr),0.7*max(fdr),c("Area method", "cFDR"),col=c("red", "blue"),pch=c(1,1)) # cFDR underestimates true FDR; area method gives good approximation.

}
\author{
James Liley
}

