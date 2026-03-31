-- ============================================================
-- Project Manager - Supabase Database Setup
-- Run this in your Supabase SQL Editor (supabase.com dashboard)
-- ============================================================

-- 1. Create tables
-- ============================================================

CREATE TABLE projecten (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project TEXT NOT NULL,
  prio INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'Niet gestart'
    CHECK (status IN ('Niet gestart', 'Onderhanden', 'Gereed')),
  planning TEXT
    CHECK (planning IS NULL OR planning IN (
      '2026-Q1','2026-Q2','2026-Q3','2026-Q4',
      '2027-Q1','2027-Q2','2027-Q3','2027-Q4'
    )),
  opmerkingen TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE onderdelen (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  onderdeel TEXT NOT NULL,
  gereed BOOLEAN NOT NULL DEFAULT FALSE,
  project_id UUID NOT NULL REFERENCES projecten(id) ON DELETE CASCADE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE taken (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  taak TEXT NOT NULL,
  door TEXT[] DEFAULT '{}',
  gereed BOOLEAN NOT NULL DEFAULT FALSE,
  onderdeel_id UUID NOT NULL REFERENCES onderdelen(id) ON DELETE CASCADE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Indexes
-- ============================================================

CREATE INDEX idx_onderdelen_project_id ON onderdelen(project_id);
CREATE INDEX idx_onderdelen_sort ON onderdelen(project_id, sort_order);
CREATE INDEX idx_taken_onderdeel_id ON taken(onderdeel_id);
CREATE INDEX idx_taken_sort ON taken(onderdeel_id, sort_order);

-- 3. Row Level Security (allow all for anon - personal app)
-- ============================================================

ALTER TABLE projecten ENABLE ROW LEVEL SECURITY;
ALTER TABLE onderdelen ENABLE ROW LEVEL SECURITY;
ALTER TABLE taken ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on projecten" ON projecten
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all on onderdelen" ON onderdelen
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all on taken" ON taken
  FOR ALL USING (true) WITH CHECK (true);

-- 4. Enable Realtime
-- ============================================================

ALTER PUBLICATION supabase_realtime ADD TABLE projecten;
ALTER PUBLICATION supabase_realtime ADD TABLE onderdelen;
ALTER PUBLICATION supabase_realtime ADD TABLE taken;

-- 5. Seed data
-- ============================================================

DO $$
DECLARE
  -- Project IDs
  p_kleedkamer UUID;
  p_balkon_boven UUID;
  p_zolder_ruwbouw UUID;
  p_kelder UUID;
  p_slaapkamer UUID;
  p_tuin UUID;
  p_voordeur UUID;
  p_hal UUID;
  p_trap UUID;
  p_zolder_afwerking UUID;
  p_balkon_onder UUID;
  p_boeien UUID;
  p_schuur UUID;
  p_woonkamer UUID;
  p_keuken UUID;
  p_kantoor UUID;
  -- Onderdeel IDs
  o_bb_algemeen UUID;
  o_bb_balustrade UUID;
  o_bo_algemeen UUID;
  o_boeien_algemeen UUID;
  o_hal_algemeen UUID;
  o_kelder_algemeen UUID;
  o_kl_algemeen UUID;
  o_kl_deur_inbouw UUID;
  o_kl_deur_kleed UUID;
  o_schuur_algemeen UUID;
  o_slaap_algemeen UUID;
  o_trap_algemeen UUID;
  o_tuin_algemeen UUID;
  o_voordeur_algemeen UUID;
  o_za_algemeen UUID;
  o_zr_algemeen UUID;
  o_zr_dakraam UUID;
BEGIN
  -- Insert Projecten
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Kleedkamer', 1, 'Onderhanden', NULL, NULL)
    RETURNING id INTO p_kleedkamer;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Balkon bovenzijde', 2, 'Niet gestart', '2026-Q2', 'Zink + schilderwerk')
    RETURNING id INTO p_balkon_boven;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Zolder ruwbouw', 3, 'Niet gestart', NULL, 'Klaar voor afbouw en als slaapruimte te gebruiken')
    RETURNING id INTO p_zolder_ruwbouw;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Kelder', 4, 'Onderhanden', NULL, 'Afhankelijk van trap Herman')
    RETURNING id INTO p_kelder;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Slaapkamer', 5, 'Niet gestart', NULL, 'Verplaatsen bed naar zolder. Warme periode i.v.m. kozijn')
    RETURNING id INTO p_slaapkamer;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Tuin', 6, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_tuin;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Voordeur', 7, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_voordeur;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Hal', 8, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_hal;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Trap', 9, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_trap;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Zolder afwerking', 10, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_zolder_afwerking;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Balkon onderzijde', 11, 'Niet gestart', NULL, 'Elektra + afwerking')
    RETURNING id INTO p_balkon_onder;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Boeien', 12, 'Niet gestart', '2027-Q2', 'Schilderwerk')
    RETURNING id INTO p_boeien;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Schuur', 13, 'Niet gestart', NULL, NULL)
    RETURNING id INTO p_schuur;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Woonkamer', 14, 'Gereed', NULL, NULL)
    RETURNING id INTO p_woonkamer;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Keuken', 15, 'Gereed', NULL, NULL)
    RETURNING id INTO p_keuken;
  INSERT INTO projecten (project, prio, status, planning, opmerkingen)
    VALUES ('Kantoor', 16, 'Gereed', NULL, NULL)
    RETURNING id INTO p_kantoor;

  -- Insert Onderdelen
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_balkon_boven, 1) RETURNING id INTO o_bb_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Balustrade', FALSE, p_balkon_boven, 2) RETURNING id INTO o_bb_balustrade;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_balkon_onder, 1) RETURNING id INTO o_bo_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_boeien, 1) RETURNING id INTO o_boeien_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_hal, 1) RETURNING id INTO o_hal_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_kelder, 1) RETURNING id INTO o_kelder_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_kleedkamer, 1) RETURNING id INTO o_kl_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Deur inbouwkast', FALSE, p_kleedkamer, 2) RETURNING id INTO o_kl_deur_inbouw;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Deur kleedkamer', FALSE, p_kleedkamer, 3) RETURNING id INTO o_kl_deur_kleed;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_schuur, 1) RETURNING id INTO o_schuur_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_slaapkamer, 1) RETURNING id INTO o_slaap_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_trap, 1) RETURNING id INTO o_trap_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_tuin, 1) RETURNING id INTO o_tuin_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_voordeur, 1) RETURNING id INTO o_voordeur_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_zolder_afwerking, 1) RETURNING id INTO o_za_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Algemeen', FALSE, p_zolder_ruwbouw, 1) RETURNING id INTO o_zr_algemeen;
  INSERT INTO onderdelen (onderdeel, gereed, project_id, sort_order)
    VALUES ('Dakraam', FALSE, p_zolder_ruwbouw, 2) RETURNING id INTO o_zr_dakraam;

  -- Insert Taken (Balkon bovenzijde > Algemeen)
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Benaderen dakdekker', ARRAY['SK'], TRUE, o_bb_algemeen, 1);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Steiger regelen', ARRAY['SK'], TRUE, o_bb_algemeen, 2);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Vloer schoonmaken', ARRAY['CH','SK'], FALSE, o_bb_algemeen, 3);

  -- Insert Taken (Balkon bovenzijde > Balustrade)
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Schoonmaken koplat+boei', ARRAY['CH','SK'], FALSE, o_bb_balustrade, 1);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Kitten rand koplat+boei', ARRAY['CH','SK'], FALSE, o_bb_balustrade, 2);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Licht opschuren koplat+boei', ARRAY['CH','SK'], FALSE, o_bb_balustrade, 3);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Lakken koplat+boei', ARRAY['CH','SK'], FALSE, o_bb_balustrade, 4);
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Zink laten plaatsen', ARRAY['Extern'], FALSE, o_bb_balustrade, 5);

  -- Insert Taken (Zolder ruwbouw > Dakraam)
  INSERT INTO taken (taak, door, gereed, onderdeel_id, sort_order)
    VALUES ('Dakramen samenstellen', ARRAY['CH','SK'], FALSE, o_zr_dakraam, 1);
END $$;
