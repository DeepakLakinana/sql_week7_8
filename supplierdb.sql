create database supplier;
use supplier;

create table suppliers (
    sid int primary key,
    sname varchar(30),
    city varchar(20)
);


create table parts (
    pid int primary key,
    pname varchar(20),
    color varchar(20)
);

create table catalog (
    sid int,
    pid int,
    cost int,
    primary key(sid, pid),
    foreign key(sid) references suppliers(sid),
    foreign key(pid) references parts(pid),
    check(cost >= 0)
);

insert into suppliers values
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

insert into parts values
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

insert into catalog values
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

select distinct pname
from parts p, catalog c
where p.pid = c.pid;

select sname
from suppliers s
where not exists (
    select pid
    from parts p
    where not exists (
        select *
        from catalog c
        where c.sid = s.sid
        and c.pid = p.pid
    )
);

select sname
from suppliers s
where not exists (
    select pid
    from parts p
    where color = 'Red'
    and not exists (
        select *
        from catalog c
        where c.sid = s.sid
        and c.pid = p.pid
    )
);

select pname
from parts p, catalog c, suppliers s
where p.pid = c.pid
and c.sid = s.sid
and sname = 'Acme Widget'
and not exists (
    select *
    from catalog c1
    where c1.pid = p.pid
    and c1.sid <> s.sid
);

select distinct sid
from catalog c
where cost > (
    select avg(cost)
    from catalog
    where pid = c.pid
);

select pid, sname
from suppliers s, catalog c
where s.sid = c.sid
and cost = (
    select max(cost)
    from catalog
    where pid = c.pid
);

select p.pname, s.sname, c.cost
from parts p, suppliers s, catalog c
where p.pid = c.pid
and s.sid = c.sid
and c.cost = (
    select max(cost)
    from catalog
);

select s.sname
from suppliers s
where not exists (
    select *
    from catalog c, parts p
    where c.pid = p.pid
    and c.sid = s.sid
    and p.color = 'red'
);

select s.sname, sum(c.cost) as total_value
from suppliers s, catalog c
where s.sid = c.sid
group by s.sid, s.sname;

select s.sname
from suppliers s, catalog c
where s.sid = c.sid
and c.cost < 20
group by s.sid, s.sname
having count(distinct c.pid) >= 2;

select p.pname, s.sname, c.cost
from parts p, suppliers s, catalog c
where p.pid = c.pid
and s.sid = c.sid
and c.cost = (
    select min(c1.cost)
    from catalog c1
    where c1.pid = p.pid
);

create view expensive_supplier as
select p.pname, s.sname, c.cost
from parts p, suppliers s, catalog c
where p.pid = c.pid
and s.sid = c.sid
and c.cost = (
    select max(c1.cost)
    from catalog c1
    where c1.pid = p.pid
);



