

CREATE DATABASE IF NOT EXISTS hirehive_db;
USE hirehive_db;


CREATE TABLE IF NOT EXISTS users (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  name             VARCHAR(100)  NOT NULL,
  email            VARCHAR(150)  NOT NULL,
  password         VARCHAR(255)  NOT NULL,
  role             ENUM('client','freelancer') NOT NULL,
  phone            VARCHAR(20)   DEFAULT '',
  skills           TEXT          DEFAULT '',
  company          VARCHAR(150)  DEFAULT '',
  bio              TEXT          DEFAULT '',
  image_url        VARCHAR(300)  DEFAULT NULL,
  profile_completed TINYINT(1)   DEFAULT 0,
  created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

  -- INDEX: Fast login lookup by email, enforces uniqueness
  UNIQUE INDEX idx_email (email)
);

-- ─── JOBS TABLE ───────────────────────────────
CREATE TABLE IF NOT EXISTS jobs (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  budget      DECIMAL(10,2) NOT NULL,
  description TEXT,
  posted_by   VARCHAR(100),
  client_id   INT NOT NULL,
  status      ENUM('open','closed') DEFAULT 'open',
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- INDEX: Fast filter by client_id (used in client dashboard)
  INDEX idx_client_id (client_id),
  -- INDEX: Fast sort by date
  INDEX idx_created_at (created_at),

  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ─── APPLICATIONS TABLE ───────────────────────
CREATE TABLE IF NOT EXISTS applications (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  job_id        INT NOT NULL,
  freelancer_id INT NOT NULL,
  status        ENUM('pending','accepted','rejected') DEFAULT 'pending',
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- INDEX: Fast lookup for freelancer's own applications
  INDEX idx_freelancer_id (freelancer_id),
  -- INDEX: Fast lookup for job's applications
  INDEX idx_job_id (job_id),
  -- Prevent duplicate applications
  UNIQUE INDEX idx_unique_application (job_id, freelancer_id),

  FOREIGN KEY (job_id)        REFERENCES jobs(id)  ON DELETE CASCADE,
  FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE
);
