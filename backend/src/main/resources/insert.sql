
insert into users (is_active, is_deleted, is_valid, is_verified, date_created)
values (true, false, true, true, now())

INSERT INTO feature_toggle (name,enabled) VALUES ('KeyCloack Create User', false);
INSERT INTO feature_toggle (name,enabled) VALUES ('Association Create', false);
INSERT INTO feature_toggle (name,enabled) VALUES ('AnafServiceImpl', false);



