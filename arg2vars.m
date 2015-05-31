function varargout = arg2vars(varargin)
% ARG2VARS   Transfer input arguments to variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The function arg2vars serves for assigning of values from input 
%   argument(s) to variables declared in the output list in the place of
%   the function calling. Not assigned output variables are empty, while
%   superfluous arguments are cut to a number of output variables. Number
%   of allocated items is a minimum out of number of input arguments and
%   number of output variables.
%
% SYNTAX:
%   [var1,...,varn] = arg2vars(x)
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   x           A single input argument. It can be a vector or matrix
%               of consistent elements, or a cell array of items.
%               Elements of matrices will be stored columnwise.
%   [var1,...]  List of names of output parameters. If length of 
%               the list were greater than the number of items in x, 
%               superfluous variables become empty. In turn, only
%               such a number of argument items is used to fill all
%               variables in the list. No error, no warnings are displayed,
%               if 
%
%   [var1,...,varn] = arg2vars(x1,...,xm)
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   x1,...,xm   list of any arguments (matrices, arrays, texts, etc.)
%
% EXAMPLES:
%   [a,b,c,d,e,f] = arg2vars(-1.234, 'abcde', [1,exp(1),pi], 1:5, eye(3))
%                                       %   a = -1.2340
%                                       %   b = abcde
%                                       %   c = 1.0000    2.7183    3.1416
%                                       %   d = 1     2     3     4     5
%                                       %   e = 1     0     0
%                                       %       0     1     0
%                                       %       0     0     1
%                                       %   f = []
%   [a,b,c,d] = arg2vars({'ABC','DEFG','HIJK'})
%                                       %   a=A, b=B, c=C, d=D, e=E, f=F
%   [a,b,c] = arg2vars({{'ABC'},{'DEFG'}})
%                                       %   a = [{1x1 cell}, {1x1 cell}]
%                                       %   b = [],  c = []
%                                       %   a{:}(2)='DEFG',  a{:}{2}=DEFG
%   [a,b,c] = arg2vars({{'ABC'}},{{'DEFG'}})
%                                       %   a = {1x1 cell}
%                                       %   b = {1x1 cell}
%                                       %   c = []
%   [a,b,c] = arg2vars(zeros(1,5),pi,{{'a','bcd','e'}},0);
%                                       %   a = 0   0   0   0   0
%                                       %   b = 3.1415926...
%                                       %   c{:} = 'a'  'bcd'  'e'
%   [E,b,c,sfa,efa,na,Ka,Nc,sc,w,ec,Nb,t,sigv,DL,D,Nz,ssq,flag,figh] = ...
%        arg2vars({repmat([],1,30)});   %   Define all variables empty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Miroslav Balda
% balda at cdm dot cas dot cz  %
%   2006-09-06  v 1.0   send 1-D cell array to output variables
%   2008-03-14  v 1.1   send any array to output variables
%   2008-08-06  v 1.2   send more arrays to output variables
%   2009-02-19  v 1.3   added spreading of cellarray into variables

nj = 0;
no = nargout;
varargout = cell(1,no);                     %   make vargouts empty

for j = 1:nargin
    if j>no, break, end
    vj = varargin{j};
    if iscell(vj) && ~iscell(vj{1})         % is it a single item?
        x = cell2mat(vj);
        n = min(no-nj,length(x));
        for k = 1:n
            varargout(nj+k) = {x(k)};       %   spread x into vars
        end
    else
        n = 1;
        varargout(nj+1) = {vj};             %   single item from varargin
    end
    nj = nj+n;
end