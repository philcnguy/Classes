clear all; clc;

N = 40;
T = 10;
mu = 0.1;
L = 5;

const = (N^2 * T) / (L^2 * mu);

for i = 1:80
    if mod(i,2) == 1
        A(i, i + 1) = 1;
    elseif mod(i,2) == 0 && i ~= 2 && i ~= 80
        A(i, i - 3) = const;
        A(i, i - 1) = -2 * const;
        A(i, i + 1) = const;
    end
end

A(2, 1) = -2 * const;
A(2, 3) = const;

A(80, 77) = const;
A(80, 79) = -2 * const;

for i = 1:40
    C(i, 2 * i - 1) = 1;
end

C(40, 80) = 0;

eigenvalues_im = sort(imag(eig(A)), 'ComparisonMethod', 'abs');

for i = 1:80
    if mod(i,2) == 1
        Ahat(i, i + 1) = eigenvalues_im(i);
    elseif mod(i,2) == 0
        Ahat(i, i - 1) = eigenvalues_im(i);
    end
end

t = linspace(0,1,40);
n_t = length(t);

figure(1)

q = zeros(80,n_t);
q(1,1) = 1;
q(2,1) = 1;

for i = 2:n_t
    q(:,i) = expm(Ahat * t(i)) * q(:,1);
end

[V,D] = eig(A);
for i = 1:80
    if mod(i,2) == 1
        X(1:80, i:i + 1) = [real(V(:,i)) imag(V(:,i))];
    end
end

x = X * q;

% plot y as a function of k (1 to 40) and t (1 to 40)

for i = 1:80
    if mod(i,2) == 0
        y(i/2, 1:40) = x(i,1:40);
    end
end

k = 1:40;
n_k = length(k);

surf(t,k,y);xlabel('Time (t)');ylabel('Index k');

figure(2)

q = zeros(80,n_t);
q(3,1) = 1;
q(4,1) = 1;

for i = 2:n_t
    q(:,i) = expm(Ahat * t(i)) * q(:,1);
end

[V,D] = eig(A);
for i = 1:80
    if mod(i,2) == 1
        X(1:80, i:i + 1) = [real(V(:,i)) imag(V(:,i))];
    end
end

x = X * q;

% plot y as a function of k (1 to 40) and t (1 to 40)

for i = 1:80
    if mod(i,2) == 0
        y(i/2, 1:40) = x(i,1:40);
    end
end

k = 1:40;
n_k = length(k);

surf(t,k,y);xlabel('Time (t)');ylabel('Index k');

figure(3)

q = zeros(80,n_t);
q(5,1) = 1;
q(6,1) = 1;

for i = 2:n_t
    q(:,i) = expm(Ahat * t(i)) * q(:,1);
end

[V,D] = eig(A);
for i = 1:80
    if mod(i,2) == 1
        X(1:80, i:i + 1) = [real(V(:,i)) imag(V(:,i))];
    end
end

x = X * q;

% plot y as a function of k (1 to 40) and t (1 to 40)

for i = 1:80
    if mod(i,2) == 0
        y(i/2, 1:40) = x(i,1:40);
    end
end

k = 1:40;
n_k = length(k);

surf(t,k,y);xlabel('Time (t)');ylabel('Index k');