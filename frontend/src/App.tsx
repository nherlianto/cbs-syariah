import { Layout, Typography } from 'antd'

const { Header, Content } = Layout

export default function App() {
  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header>
        <Typography.Title level={4} style={{ color: '#fff', margin: '16px 0' }}>
          CBS Syariah · Back Office
        </Typography.Title>
      </Header>
      <Content style={{ padding: 24 }}>
        <Typography.Paragraph>Modules will appear here as they are built.</Typography.Paragraph>
      </Content>
    </Layout>
  )
}
