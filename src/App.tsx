import React, { useState } from 'react';
import './App.css';

interface VideoConfig {
  topic: string;
  duration: number;
  language: string;
  backgroundColor: string;
  accentColor: string;
  resolution: string;
}

const App: React.FC = () => {
  const [config, setConfig] = useState<VideoConfig>({
    topic: 'Trí Tuệ Nhân Tạo',
    duration: 60,
    language: 'vi',
    backgroundColor: '#0a0e27',
    accentColor: '#00d4ff',
    resolution: '1920x1080',
  });

  const [isLoading, setIsLoading] = useState(false);
  const [output, setOutput] = useState<string>('');
  const [error, setError] = useState<string>('');

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setConfig((prev) => ({
      ...prev,
      [name]: name === 'duration' ? parseInt(value) : value,
    }));
  };

  const handleCreateVideo = async () => {
    setIsLoading(true);
    setOutput('');
    setError('');

    try {
      // Call backend API to create video
      const response = await fetch('/api/create-video', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(config),
      });

      if (!response.ok) {
        throw new Error(`Error: ${response.statusText}`);
      }

      const data = await response.json();
      setOutput(data.videoPath);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error occurred');
    } finally {
      setIsLoading(false);
    }
  };

  const colorSchemes = [
    { name: 'Blue & Cyan', bg: '#0a0e27', accent: '#00d4ff' },
    { name: 'Purple & Pink', bg: '#1a0033', accent: '#ff6b9d' },
    { name: 'Green & Lime', bg: '#0d1f0d', accent: '#00ff00' },
    { name: 'Red & Gold', bg: '#2d0a0a', accent: '#ffaa00' },
  ];

  return (
    <div className="app-container">
      <header className="app-header">
        <div className="header-content">
          <h1>🎬 Video Creator Tool</h1>
          <p>Create professional videos with AI-powered voice over</p>
        </div>
      </header>

      <main className="app-main">
        <div className="content-wrapper">
          {/* Left Panel - Preview */}
          <section className="preview-section">
            <div className="preview-box">
              <div
                className="video-preview"
                style={{
                  backgroundColor: config.backgroundColor,
                  borderColor: config.accentColor,
                }}
              >
                <div className="preview-content">
                  <div className="rotating-circle" style={{ borderColor: config.accentColor }}></div>
                  <h2 className="preview-title" style={{ color: '#ffffff' }}>
                    {config.topic}
                  </h2>
                  <p className="preview-subtitle" style={{ color: config.accentColor }}>
                    Video được tạo tự động
                  </p>
                  <div className="preview-bar" style={{ backgroundColor: config.accentColor }}></div>
                </div>
              </div>
              <p className="preview-label">Preview</p>
            </div>
          </section>

          {/* Right Panel - Controls */}
          <section className="control-section">
            <form className="form-container">
              <div className="form-group">
                <label htmlFor="topic">Chủ Đề Video *</label>
                <input
                  type="text"
                  id="topic"
                  name="topic"
                  value={config.topic}
                  onChange={handleInputChange}
                  placeholder="Nhập chủ đề của bạn..."
                  className="form-input"
                />
                <small>Ví dụ: Trí Tuệ Nhân Tạo, Python Programming, etc.</small>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="duration">Thời Lượng (giây)</label>
                  <input
                    type="number"
                    id="duration"
                    name="duration"
                    value={config.duration}
                    onChange={handleInputChange}
                    min="30"
                    max="300"
                    className="form-input"
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="language">Ngôn Ngữ</label>
                  <select
                    id="language"
                    name="language"
                    value={config.language}
                    onChange={handleInputChange}
                    className="form-input"
                  >
                    <option value="vi">Tiếng Việt</option>
                    <option value="en">English</option>
                    <option value="es">Español</option>
                    <option value="fr">Français</option>
                    <option value="de">Deutsch</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="resolution">Độ Phân Giải</label>
                <select
                  id="resolution"
                  name="resolution"
                  value={config.resolution}
                  onChange={handleInputChange}
                  className="form-input"
                >
                  <option value="1280x720">HD (1280x720)</option>
                  <option value="1920x1080">Full HD (1920x1080)</option>
                  <option value="3840x2160">4K (3840x2160)</option>
                </select>
              </div>

              <div className="form-group">
                <label>Lựa Chọn Màu Sắc</label>
                <div className="color-schemes">
                  {colorSchemes.map((scheme) => (
                    <button
                      key={scheme.name}
                      type="button"
                      className={`color-scheme ${
                        config.backgroundColor === scheme.bg ? 'active' : ''
                      }`}
                      onClick={() =>
                        setConfig((prev) => ({
                          ...prev,
                          backgroundColor: scheme.bg,
                          accentColor: scheme.accent,
                        }))
                      }
                      title={scheme.name}
                    >
                      <div
                        className="color-preview"
                        style={{
                          background: `linear-gradient(135deg, ${scheme.bg}, ${scheme.accent})`,
                        }}
                      ></div>
                      <span>{scheme.name}</span>
                    </button>
                  ))}
                </div>
              </div>

              <div className="form-group">
                <label>Custom Colors</label>
                <div className="custom-colors">
                  <div className="color-input-group">
                    <label>Background</label>
                    <input
                      type="color"
                      value={config.backgroundColor}
                      onChange={(e) =>
                        setConfig((prev) => ({
                          ...prev,
                          backgroundColor: e.target.value,
                        }))
                      }
                      className="color-picker"
                    />
                    <code>{config.backgroundColor}</code>
                  </div>
                  <div className="color-input-group">
                    <label>Accent</label>
                    <input
                      type="color"
                      value={config.accentColor}
                      onChange={(e) =>
                        setConfig((prev) => ({
                          ...prev,
                          accentColor: e.target.value,
                        }))
                      }
                      className="color-picker"
                    />
                    <code>{config.accentColor}</code>
                  </div>
                </div>
              </div>

              <button
                type="button"
                onClick={handleCreateVideo}
                disabled={isLoading || !config.topic.trim()}
                className={`create-button ${isLoading ? 'loading' : ''}`}
              >
                {isLoading ? (
                  <>
                    <span className="spinner"></span>
                    Đang tạo video...
                  </>
                ) : (
                  <>
                    🎬 Tạo Video
                  </>
                )}
              </button>
            </form>
          </section>
        </div>

        {/* Output Section */}
        {output && (
          <section className="output-section success">
            <div className="output-content">
              <h3>✅ Video Tạo Thành Công!</h3>
              <p>Video của bạn đã được lưu:</p>
              <code className="output-path">{output}</code>
              <div className="output-actions">
                <button className="secondary-button">📁 Mở Thư Mục</button>
                <button className="secondary-button">📥 Download</button>
              </div>
            </div>
          </section>
        )}

        {error && (
          <section className="output-section error">
            <div className="output-content">
              <h3>❌ Lỗi</h3>
              <p>{error}</p>
              <button className="secondary-button" onClick={() => setError('')}>
                Đóng
              </button>
            </div>
          </section>
        )}
      </main>

      {/* Footer */}
      <footer className="app-footer">
        <p>© 2024 Video Creator Tool - Powered by Remotion</p>
        <div className="footer-links">
          <a href="https://www.remotion.dev" target="_blank" rel="noopener noreferrer">
            Remotion Docs
          </a>
          <a href="https://github.com" target="_blank" rel="noopener noreferrer">
            GitHub
          </a>
        </div>
      </footer>
    </div>
  );
};

export default App;
