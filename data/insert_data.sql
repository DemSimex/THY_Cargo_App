USE thy_cargo;

INSERT INTO Region (name) VALUES
('Balkans'),
('Middle Europe'),
('South Europe'),
('East Europe'),
('West Europe'),
('North Europe');

INSERT INTO Country (name, region_id) VALUES
('Albania', 1),
('Austria', 2),
('Belarus', 4),
('Belgium', 5),
('Bosnia', 1),
('Bulgaria', 1),
('Croatia', 1),
('Czech Rep', 2),
('Denmark', 6),
('Estonia', 6),
('Finland', 6),
('France', 5),
('Germany', 2),
('Greece', 1),
('Hungary', 2),
('Italy', 3),
('Kosovo', 1),
('Latvia', 6),
('Lithuania', 6),
('Luxembourg', 5),
('Macedonia', 1),
('Malta', 3),
('Moldovo', 4),
('Montenegro', 1),
('Netherlands', 5),
('Norway', 6),
('Poland', 2),
('Portugal', 3),
('Romania', 1),
('Russia', 4),
('Serbia', 1),
('Slovakia', 2),
('Slovenia', 1),
('Spain', 3),
('Sweden', 6),
('Switzerland', 2);

INSERT INTO Cargo_Category (category_name, rate_multiplier) VALUES
('General Cargo (GEN)', 1.00),
('Perishable Cargo (PER)', 1.25),
('Dangerous Goods (DGR)', 1.50),
('Pharmaceuticals & Medical (PIL)', 1.60),
('Live Animals (AVI)', 1.75),
('Valuable Cargo (VAL)', 2.00);

INSERT INTO Handling_Service (service_name, fee) VALUES
('Air Waybill (AWB) Documentation Fee', 25.00),
('X-Ray & Security Screening', 35.00),
('Customs Clearance & Terminal Handling', 50.00),
('Cold Storage & Temperature Control', 60.00),
('Dangerous Goods (DGR) Inspection Fee', 75.00),
('Local Pick-up & Delivery Service', 80.00);

