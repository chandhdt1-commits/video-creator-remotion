# 📹 Video Creator Tool - Remotion Version

Advanced video creation tool using **Remotion** framework with professional animations and voice over support.

## ✨ Tính năng

- ✅ **Smooth Animations** - Spring animations, fade effects, scaling
- ✅ **Voice Over** - Tự động tạo voice bằng gTTS
- ✅ **Dynamic Content** - Nhập chủ đề, tự động generate video
- ✅ **High Quality** - Full HD 1920x1080 @ 60fps
- ✅ **Multiple Formats** - MP4, WebM, GIF support
- ✅ **Real-time Preview** - Xem preview trong khi phát triển
- ✅ **Professional Effects** - Gradient backgrounds, rotating elements
- ✅ **Customizable Colors** - Thay đổi background, accent colors
- ✅ **Modern UI** - Beautiful React-based interface

## 🚀 Installation

### Yêu cầu
- Node.js >= 16
- FFmpeg
- npm hoặc yarn

### Setup

```bash
# Clone/download project
cd video-creator-remotion

# Run setup script (automatic)
chmod +x setup.sh
./setup.sh

# Or manual install
npm install
```

## 📖 Hướng dẫn Sử dụng

### 1. Chạy Web UI
```bash
npm run dev
```
Mở http://localhost:3000 trong browser

### 2. Tạo Video bằng UI
- Nhập chủ đề video
- Chọn thời lượng (30-300 giây)
- Chọn ngôn ngữ (Tiếng Việt, English, etc)
- Chọn màu sắc hoặc custom colors
- Click "Tạo Video"

### 3. Tạo Video bằng CLI
```bash
# Cách 1: Chủ đề mặc định
npm run create:video

# Cách 2: Tùy chỉnh chủ đề
tsx src/video-creator-cli.ts "Trí Tuệ Nhân Tạo" 60 vi

# Cách 3: Sử dụng script
npm run create:topic
```

### 4. Render Video Final
```bash
# Render composition
npm run build

# Với tùy chọn nâng cao
remotion render video-with-audio output.mp4 --fps 60 --codec h264
```

## 📁 Project Structure

```
video-creator-remotion/
├── src/
│   ├── App.tsx                          # Main React UI component
│   ├── App.css                          # UI styles
│   ├── index.tsx                        # Remotion entry point
│   ├── remotion-video-composition.tsx   # Video compositions
│   └── video-creator-cli.ts             # CLI tool
├── package.json                         # Dependencies
├── tsconfig.json                        # TypeScript config
├── remotion.config.ts                   # Remotion config
├── setup.sh                             # Automatic setup script
├── README.md                            # This file
├── QUICK_START.md                       # Quick start guide
└── videos/                              # Output videos
    └── output/
```

## 🎬 Composition Structure

### `video-basic`
- Thời lượng: 30 giây
- Chứa: Title animation, subtitle, decorative elements
- Không có audio

### `video-with-audio`
- Thời lượng: 60 giây
- Chứa: Đầy đủ animations + voice over
- Với background music support

## 🎨 Tùy chỉnh Video

### Thay đổi màu sắc trong UI
1. Mở http://localhost:3000
2. Chọn color scheme từ presets
3. Hoặc dùng custom color picker
4. Preview sẽ update realtime

### Thay đổi màu sắc trong CLI
Edit `src/video-creator-cli.ts`:
```typescript
const creator = new RemotionVideoCreator({
  topic: 'Your Topic',
  duration: 60,
  language: 'vi',
  backgroundColor: '#1a1a2e',
  accentColor: '#ff6b9d',
});
```

### Color Schemes Available

| Tên | Background | Accent |
|-----|-----------|--------|
| Blue & Cyan | #0a0e27 | #00d4ff |
| Purple & Pink | #1a0033 | #ff6b9d |
| Green & Lime | #0d1f0d | #00ff00 |
| Red & Gold | #2d0a0a | #ffaa00 |

### Thêm custom animations
Edit `src/remotion-video-composition.tsx`:
```typescript
// Ví dụ: Thêm slide-in effect
const slideIn = interpolate(frame, [0, fps * 0.5], [-100, 0]);
// Áp dụng: transform: `translateX(${slideIn}px)`
```

## 📊 Video Output Formats

```bash
# MP4 (mặc định - H.264)
npm run build

# WebM (VP9 codec)
remotion render video-with-audio output.webm --codec vp9

# GIF
remotion render video-with-audio output.gif --codec gif

# ProRes (Apple)
remotion render video-with-audio output.mov --codec prores

# Full quality MP4
npm run build:production
```

## 🔧 Troubleshooting

### Lỗi: "FFmpeg not found"
```bash
# Windows (choco)
choco install ffmpeg

# Mac (brew)
brew install ffmpeg

# Linux (apt)
sudo apt-get install ffmpeg

# Linux (yum)
sudo yum install ffmpeg
```

### Lỗi: "Cannot find module 'remotion'"
```bash
npm install remotion @remotion/cli @remotion/renderer
```

### Voice over không hoạt động
```bash
# Cài đặt gtts command-line
pip install gtts

# Test
gtts-cli "Hello World" --lang en --file test.mp3
```

### Preview server không chạy (Port 3000)
```bash
# Kill existing process
lsof -ti:3000 | xargs kill -9  # macOS/Linux
netstat -ano | findstr :3000   # Windows

# Start again
npm run dev
```

### Node modules issue
```bash
# Clear cache
rm -rf node_modules package-lock.json
npm install
```

## 📈 Performance Tips

- 🚀 Dùng `--concurrency 4` khi render để tăng tốc độ
- 🎬 Giảm FPS xuống 30 nếu không cần chất lượng cao
- 💾 Dùng `--quality low` cho preview, `high` cho final
- ⚡ Render từng composition riêng biệt để tránh lỗi
- 🔄 Cache results: Remotion tự động cache previews

## 🔗 Useful Links

- [Remotion Documentation](https://www.remotion.dev/docs)
- [Remotion CLI Reference](https://www.remotion.dev/docs/cli)
- [Animation Tutorial](https://www.remotion.dev/docs/tutorials/animation)
- [gTTS Documentation](https://gtts.readthedocs.io/)
- [React Hooks Guide](https://react.dev/reference/react/hooks)

## 📝 Advanced Usage

### Render with Custom Input Props
```bash
remotion render video-with-audio output.mp4 \
  --props '{"topic":"Machine Learning","accentColor":"#ff6b9d"}'
```

### Batch Processing Videos
Create `batch-render.sh`:
```bash
#!/bin/bash
topics=("AI" "Python" "JavaScript" "Blockchain")
for topic in "${topics[@]}"; do
  remotion render video-with-audio "output_${topic}.mp4" \
    --props "{\"topic\":\"$topic\"}" \
    --quality high
done
```

Run it:
```bash
chmod +x batch-render.sh
./batch-render.sh
```

### Server-side Rendering (Production)
```typescript
import { render } from '@remotion/renderer';
import express from 'express';

const app = express();

app.post('/api/create-video', async (req, res) => {
  const { topic, duration } = req.body;
  
  const videoPath = await render({
    composition: 'video-with-audio',
    serveUrl: 'http://localhost:3000',
    codec: 'h264',
    fps: 60,
    width: 1920,
    height: 1080,
    durationInFrames: duration * 60,
    outputLocation: `./videos/${topic}.mp4`,
    inputProps: { topic, duration },
  });
  
  res.json({ videoPath });
});
```

### Docker Deployment
```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "dev"]
```

## 🌍 Language Support

Supported languages via gTTS:
- Tiếng Việt (vi)
- English (en)
- Español (es)
- Français (fr)
- Deutsch (de)
- 日本語 (ja)
- 中文 (zh)
- And many more...

[Full list](https://gtts.readthedocs.io/en/latest/module.html#module-gtts.lang)

## 📄 API Reference

### VideoCreatorOptions
```typescript
interface VideoCreatorOptions {
  topic: string;              // Video topic
  duration: number;           // Duration in seconds (30-300)
  language: string;           // Language code (vi, en, etc)
  outputDir: string;          // Output directory
  backgroundColor?: string;   // Hex color
  accentColor?: string;       // Hex color
  fps?: number;              // Frames per second (default: 60)
  resolution?: [number, number]; // [width, height]
}
```

### RemotionVideoCreator
```typescript
class RemotionVideoCreator {
  create(): Promise<string>;           // Create video
  generateVoiceOver(): Promise<string>; // Generate audio
  renderVideo(audioPath: string): Promise<string>; // Render
}
```

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 Giấy phép
MIT License 2024

## 👥 Support

- 📧 Email: support@example.com
- 💬 Discord: [Join server]
- 🐛 Issues: GitHub Issues
- 📚 Wiki: [GitHub Wiki]

## 🎉 Changelog

### v2.0.0 (Current)
- ✅ Remotion framework integration
- ✅ Modern React UI
- ✅ Advanced animations
- ✅ Real-time preview
- ✅ Multiple color schemes
- ✅ CLI tool

### v1.0.0
- Initial release with basic video generation

---

**Made with ❤️ by Video Creator Team**
