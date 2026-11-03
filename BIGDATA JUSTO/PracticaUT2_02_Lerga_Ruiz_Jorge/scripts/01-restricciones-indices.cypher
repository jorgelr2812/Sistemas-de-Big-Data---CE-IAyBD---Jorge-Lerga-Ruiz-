// 1. RESTRICCIONES DE UNICIDAD
CREATE CONSTRAINT c_animal_id IF NOT EXISTS FOR (a:Animal) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT c_protectora_id IF NOT EXISTS FOR (p:Protectora) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT c_casa_id IF NOT EXISTS FOR (c:CasaAcogida) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT c_adoptante_id IF NOT EXISTS FOR (u:Adoptante) REQUIRE u.id IS UNIQUE;

// 2. ÍNDICES SECUNDARIOS
CREATE INDEX idx_animal_nombre IF NOT EXISTS FOR (a:Animal) ON (a.nombre);
CREATE INDEX idx_protectora_ciudad IF NOT EXISTS FOR (p:Protectora) ON (p.ciudad);
CREATE INDEX idx_casa_zona IF NOT EXISTS FOR (c:CasaAcogida) ON (c.zona);